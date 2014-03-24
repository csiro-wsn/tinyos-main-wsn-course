configuration TagMoteAppC {
} implementation {
  components MainC;  
  components new TimerMilliC() as ReportTimer;
  components TagMoteC as App, LedsC;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.ReportTimer -> ReportTimer;

  components IPStackC,RFA1RadioC,RFA1Ieee154MessageC;
  App.RadioControl -> IPStackC;
  App.RssiReceive -> RFA1RadioC.Ieee154Receive;
  App.Ieee154Packet -> RFA1RadioC;
  App -> RFA1Ieee154MessageC.PacketRSSI;
   
  components new UdpSocketC() as ReportService;
  App.ReportService -> ReportService;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif
  // UDP shell on port 2000
  components UDPShellC;

  // printf on serial port
  components SerialPrintfC, SerialStartC;



}

