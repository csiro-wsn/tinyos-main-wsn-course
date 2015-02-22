from socket import *
from struct import pack
 
UDPSock = socket(AF_INET6,SOCK_DGRAM)
address=raw_input("Enter mote ip address:")
UDPSock.connect((address,1234))
led = pack('B',int(raw_input("Enter led code:")))
UDPSock.send(led)
