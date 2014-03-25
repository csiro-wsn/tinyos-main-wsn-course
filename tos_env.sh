#!/bin/sh


export TOSROOT=/home/$USER/tinyos-2.x
export TOSDIR=$TOSROOT/tos
export PATH=$PATH:$TOSROOT/support/sdk/c/sf
export CLASSPATH=$TOSROOT/support/sdk/java/tinyos.jar:.
export PYTHONPATH=$PYTHONPATH:$TOSROOT/support/sdk/python
export MAKERULES=$TOSROOT/support/make/Makerules
