/*
 * Copyright (c) 2013 CSIRO
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Philipp Sommer <philipp.sommer@csiro.au>
 */


#include "Timer.h"
#include "printf.h"

module SerialConsoleC {
  uses {
    interface Boot;
    interface Leds;

    interface StdControl as SerialControl;
    interface UartStream;

    interface Timer<TMilli> as MilliTimer;
  }
}

implementation {

  uint8_t counter = 0;
  uint8_t buffer[64];
  uint8_t state = 0;

 

  event void Boot.booted() {
    call SerialControl.start();
    call MilliTimer.startPeriodic(1000);
  }
  
  event void MilliTimer.fired() {
    call Leds.led0Toggle();
    counter++;

    buffer[0] = (counter & 0x7) + '0';
    buffer[1] = '\n';
    call UartStream.send(buffer, 2);  
  }

  /**
   * Signals the receipt of a byte.
   * @param byte The byte received.
   */
  async event void UartStream.receivedByte( uint8_t byte ) {
    call Leds.led1Toggle();
    call Leds.led2Toggle();
  }
  
  /**
   * Signal completion of receiving a stream.
   * @param 'uint8_t* COUNT(len) buf' Buffer for bytes received.
   * @param len Number of bytes received.
   * @param error SUCCESS if the reception was successful, FAIL otherwise.
   */
  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
    // not implemented
  }


  /**
   * Signal completion of sending a stream.
   * @param 'uint8_t* COUNT(len) buf' Bytes sent.
   * @param len Number of bytes sent.
   * @param error SUCCESS if the transmission was successful, FAIL otherwise.
   */
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {
    // not implemented
  }


}




