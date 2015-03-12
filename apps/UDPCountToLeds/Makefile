COMPONENT=UdpCountToLedsAppC
CFLAGS += -DNEW_PRINTF_SEMANTICS
# Disables support for the AM stack, which somewhat reduces code size
# and compresses packet formats.  If you want to use other tinyos
# protocols which are AM-based, you should not include this.
CFLAGS += -DIEEE154FRAMES_ENABLED


# radio options
CFLAGS += -DRF230_DEF_CHANNEL=11

# use hardware ack
CFLAGS+=-DRF230_HARDWARE_ACK
CFLAGS += -DSOFTWAREACK_TIMEOUT=3000

# you can compile with or without a routing protocol... of course,
# without it, you will only be able to use link-local communication.
#PFLAGS += -DRPL_ROUTING -DRPL_STORING_MODE -I$(TOSDIR)/lib/net/rpl

# if you're using DHCP, set this to try and derive a 16-bit address
# from the IA received from the server.  This will work if the server
# gives out addresses from a /112 prefix.  If this is not set, blip
# will only use EUI64-based link addresses.  If not using DHCP, this
# causes blip to use TOS_NODE_ID as short address.  Otherwise the
# EUI will be used in either case.
PFLAGS += -DBLIP_DERIVE_SHORTADDRS

# this disables dhcp and statically chooses a prefix.  the motes form
# their ipv6 address by combining this with TOS_NODE_ID
PFLAGS += -DIN6_PREFIX=\"fec0::\"

include $(MAKERULES)
