#include "Timer.h"
#include "RssiRanging.h"
#include <IPDispatch.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>
#include "printf.h"


module TagMoteC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as ReportTimer;
  uses interface SplitControl as RadioControl;

  uses interface UDP as ReportService;
  uses interface Receive as RssiReceive;
  uses interface Ieee154Packet;
  uses interface PacketField<uint8_t> as PacketRSSI;

} implementation {
  ReportMsg report_msg_data;
  struct sockaddr_in6 route_dest;

  typedef struct neighbor_t{
    int16_t rssi_sum;
    uint8_t num;
  } neighbor_t;
  neighbor_t ntable[NUM_NODES];

  void initNTable() {
    uint8_t i=0;
    for (i=0; i<NUM_NODES; i++) {
      ntable[i].rssi_sum=0;
      ntable[i].num=0;
    }
  }

  uint16_t getRssi(message_t *msg);

  event void Boot.booted(){
    call RadioControl.start();
    route_dest.sin6_port = htons(REPORTMSG_PORT);
    inet_pton6(BASE_ADDR, &route_dest.sin6_addr);

    report_msg_data.id = TOS_NODE_ID;
    initNTable();
  }

  event void RadioControl.startDone(error_t result){
    call ReportService.bind(REPORTMSG_PORT);
    call ReportTimer.startPeriodic(SEND_REPORT_MS);
  }

  event void RadioControl.stopDone(error_t result){}

  task void sendReport();

  event void ReportTimer.fired(){
    post sendReport();
  }

  event message_t* RssiReceive.receive(message_t *msg, void *payload, uint8_t len) {
    uint8_t id = (uint8_t)(call Ieee154Packet.source(msg)); 
    int16_t rssi = getRssi(msg);
    uint8_t idx = id - 10;
    printf("Rssi msg received from node %d: %d dBm\n", id, rssi);
    if (idx < NUM_NODES) {
      ntable[idx].rssi_sum = rssi;
      ntable[idx].num=1;
      call Leds.led1Toggle();
    }
    return msg;
  }
  event void ReportService.recvfrom(struct sockaddr_in6 *src, void *payload, 
                      uint16_t len, struct ip6_metadata *meta) {
                      }

  task void sendReport() {
    uint8_t i=0;
    printf("RSSI Summary: [");
    for(i=0; i<NUM_NODES; i++) {
      if(ntable[i].num==0)
        report_msg_data.rssi[i]=UNDEF_RSSI;
      else
        report_msg_data.rssi[i]=ntable[i].rssi_sum/ntable[i].num;
      printf("%d,",report_msg_data.rssi[i]);
    }
    printf("]\r\n");
    printfflush();
    initNTable();

    call ReportService.sendto(&route_dest,&report_msg_data,sizeof(ReportMsg));
    call Leds.led0Toggle();
  }


  uint16_t getRssi(message_t *msg){
    if(call PacketRSSI.isSet(msg))
      return (uint16_t) (-90 + 3 *(call PacketRSSI.get(msg)-1));
    else
      return 0xFFFF;
  }

}
