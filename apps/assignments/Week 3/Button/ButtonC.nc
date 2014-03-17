
/**
 * 
 * Button demo application.
 *
 * @author Philipp Sommer
 */

#include "Timer.h"

module ButtonC
{
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli>;
    interface GeneralIO as Button;
    interface GpioInterrupt;
  }
}
implementation
{

  // sampling frequency in binary milliseconds
  #define SAMPLING_FREQUENCY 1000
  
  event void Boot.booted() {

    // configure button pin as input
    call Button.makeInput();

    call Timer.startPeriodic(SAMPLING_FREQUENCY);
    
    // TODO: add your code here 

  }

  event void Timer.fired() 
  {
    // check status of input and set/clear LED accordingly
    bool button = call Button.get();

    if (button) call Leds.led1On();
    else call Leds.led1Off();

    // toggle green LED
    call Leds.led0Toggle();
  }
 
  async event void GpioInterrupt.fired() {
    // TODO: add your code here 
  }

}

