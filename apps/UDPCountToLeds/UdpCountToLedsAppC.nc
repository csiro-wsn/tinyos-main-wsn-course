configuration UdpCountToLedsAppC {}
implementation {
  components MainC;
  components UdpCountToLedsC as App;
  components LedsC;

  components new TimerMilliC();
 
  components IPStackC;
  App.RadioControl -> IPStackC;
 
#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif
  
#ifndef  IN6_PREFIX
  components DhcpCmdC;
#endif

  components new UdpSocketC() as LedService;
  App.LedService -> LedService;
 
  App.Boot -> MainC.Boot;
 
  App.Leds -> LedsC;
  App.MilliTimer -> TimerMilliC;
  
  components SerialPrintfC;
}

