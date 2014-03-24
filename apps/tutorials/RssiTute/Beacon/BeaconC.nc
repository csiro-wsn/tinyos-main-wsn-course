#include "RssiRanging.h"
#include <IPDispatch.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>
 

module BeaconC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as BeaconTimer;
  uses interface SplitControl as RadioControl;
  uses interface UDP as RssiService;
 
} implementation {
  RssiMsg rssi_payload;
  struct sockaddr_in6 dest;
	
  event void Boot.booted(){
    call RadioControl.start();
    rssi_payload.id = TOS_NODE_ID;
  }

  event void RadioControl.startDone(error_t result){
    call BeaconTimer.startPeriodic(SEND_BEACON_MS);
    call RssiService.bind(RSSIMSG_PORT);
  }

  event void RadioControl.stopDone(error_t result){}

  event void BeaconTimer.fired(){
    inet_pton6("ff02::2", &dest.sin6_addr);
    dest.sin6_port = htons(RSSIMSG_PORT);
    call RssiService.sendto(&dest,&rssi_payload,sizeof(RssiMsg));
    call Leds.led0Toggle();
  }

  event void RssiService.recvfrom(struct sockaddr_in6 *src, void *payload, 
                      uint16_t len, struct ip6_metadata *meta) {}
}

