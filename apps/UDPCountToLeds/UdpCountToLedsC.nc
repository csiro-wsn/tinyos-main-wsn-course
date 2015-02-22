#include "Timer.h"
#include "UdpCountToLeds.h"
#include <IPDispatch.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>
#include "printf.h"
 
module UdpCountToLedsC {
  uses {
    interface Leds;
    interface Boot;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as RadioControl;
    interface UDP as LedService;
  }
}
implementation {
 
  radio_count_msg_t radio_payload;
  uint8_t counter;
  struct sockaddr_in6 dest;
 
  event void Boot.booted() {
    call RadioControl.start();
  }
 
  event void RadioControl.startDone(error_t e) {
    call MilliTimer.startPeriodic(1000);
    call LedService.bind(1234);
  }
 
  event void RadioControl.stopDone(error_t e) { } //nothing to do
 
  event void LedService.recvfrom(struct sockaddr_in6 *src, void *payload, 
                      uint16_t len, struct ip6_metadata *meta)
  {   
    radio_count_msg_t * msg = payload;
    if(len == sizeof(radio_count_msg_t))
    {
      char addr[20];
      inet_ntop6(&(src->sin6_addr), addr, 20);
      printf("Packet from %s, counter %u\n", addr, msg->counter); 
      printfflush();
      call Leds.set(msg->counter);
      call LedService.sendto(src, payload, len);
    }
    else
    {
      uint8_t i;
      uint8_t *cur = payload;
      for (i = 0; i < len; i++) {
        printf("%02x ", cur[i]);
      }
      printf("\n");
    }
  }
 
 
  event void MilliTimer.fired() {
    counter++;
    radio_payload.counter=counter;
    inet_pton6("ff02::1", &dest.sin6_addr);
    //inet_pton6("fec0::100", &dest.sin6_addr);
    dest.sin6_port = htons(1234);
    call LedService.sendto(&dest,&radio_payload,sizeof(radio_count_msg_t));
  }
 
 
}


