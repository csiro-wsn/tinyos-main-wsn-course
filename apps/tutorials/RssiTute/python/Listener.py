#!/usr/bin/python

import socket
import ReportMsg
import re
import sys


if __name__ == '__main__':
    port = 7011

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))
    print "Listening"
    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = ReportMsg.ReportMsg(data=data, data_length=len(data))

            print rpt.get_id(), rpt.get_rssi()

