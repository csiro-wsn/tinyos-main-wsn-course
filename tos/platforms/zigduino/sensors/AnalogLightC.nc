

generic configuration AnalogLightC(uint8_t channel) {
  provides interface Read<uint16_t>;
}
implementation {
  components new AdcReadClientC(), new ZigduinoAdcConfigC(channel, ATM128_ADC_VREF_OFF);

  Read = AdcReadClientC;
  AdcReadClientC.Atm128AdcConfig -> ZigduinoAdcConfigC;
}
