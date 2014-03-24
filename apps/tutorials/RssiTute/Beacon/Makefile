COMPONENT=BeaconAppC
CFLAGS += -I..
CFLAGS += -DRFA1_DEF_RFPOWER=0
# Disables support for the AM stack, which somewhat reduces code size
# and compresses packet formats.  If you want to use other tinyos
# protocols which are AM-based, you should not include this.
CFLAGS += -DIEEE154FRAMES_ENABLED

include $(MAKERULES)
