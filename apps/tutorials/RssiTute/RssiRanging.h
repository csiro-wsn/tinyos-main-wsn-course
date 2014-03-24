#ifndef RSSIRANGING_H__
#define RSSIRANGING_H__

#define BASE_ADDR "fec0::100"

enum {
  NUM_NODES = 5,
  SEND_BEACON_MS = 250,
  SEND_REPORT_MS = 1000,
  UNDEF_RSSI = 127,
  RSSIMSG_PORT = 7010,
  REPORTMSG_PORT = 7011,
};

typedef nx_struct RssiMsg{
  nx_uint8_t id;
} RssiMsg;

typedef nx_struct ReportMsg{
  nx_uint8_t id;
  nx_int8_t rssi[NUM_NODES];
} ReportMsg;

#endif
