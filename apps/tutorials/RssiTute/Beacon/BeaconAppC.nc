configuration BeaconAppC {
} implementation {
  components MainC;  
  components BeaconC as App, LedsC;
  components new TimerMilliC() as BeaconTimer;

  components IPStackC;
  App.RadioControl -> IPStackC;
 
  components new UdpSocketC() as RssiService;
  App.RssiService -> RssiService;
 
  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.BeaconTimer -> BeaconTimer;
}
