/**
 * 
 * Button demo application.
 * 
 * @author Philipp Sommer
 */

configuration ButtonAppC 
{ 
} 
implementation { 
  
  components ButtonC, MainC, LedsC, new TimerMilliC();

  ButtonC.Boot -> MainC;
  ButtonC.Leds -> LedsC;
  ButtonC.Timer -> TimerMilliC;

  components ZigduinoDigitalPortsC;
  ButtonC.Button -> ZigduinoDigitalPortsC.Digital1;

  ButtonC.GpioInterrupt -> ZigduinoDigitalPortsC.Interrupt1;

}

