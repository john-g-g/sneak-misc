#!/usr/bin/env python

import requests
import subprocess
import sys
import json
import re

def main():
    aps = nmcli2api(nmcli())
    print aps
    print geolocate(wifidata=aps)

def geolocate(wifidata=None):
    url = "https://location.services.mozilla.com/v1/geolocate?key=test"
    postdata = { }
    if wifidata:
        postdata['wifiAccessPoints'] = wifidata
    return None #requests.post(url, data=json.dumps(wifidata))

def _parse_nmcli(text):
    lines = [ 
        x for x in text.split('\n') 
            if re.match('^AP\[', x)
    ]
    output = []
    for line in lines:
        m = re.match('AP\[(\d+)\]\.(\w+):(.*)',line)
        if m:
            output.append([ 
                m.group(1), 
                m.group(2).lower(), 
                m.group(3)
            ])
    a = {}
    for item in output:
        if not a.get(item[0]):
            a[item[0]] = {}
        a[item[0]][item[1]] = item[2]
    return a.values()
    
def nmcli2api(aps):
    """
    {
        "macAddress": "01:23:45:67:89:AB",
        "signalStrength": -65,
        "age": 0,
        "channel": 11,
        "signalToNoiseRatio": 40
    }
    """
    output = []
    for ap in aps:
        x = {}
        x['macAddress'] = 
        print ap

def nmcli():
    cmd = "nmcli -t device list".split(' ')
    output = subprocess.check_output(cmd)
    return _parse_nmcli(output)

sys.exit(main())

# fetched from wikipedia on 2015-04-27
# https://en.wikipedia.org/wiki/List_of_WLAN_channels
WIFI_FREQUENCIES = {
    '2412': 1,  '2417': 2, '2422': 3, '2427': 4, '2432': 5, '2437': 6,
    '2442': 7,  '2447': 8, '2452': 9, '2457': 10, '2462': 11, '2467': 12,
    '2472': 13, '2484': 14, '3657.5': 131, '3660.0': 132, '3662.5': 132,
    '3665.0': 133, '3667.5': 133, '3670.0': 134, '3672.5': 134, '3675.0': 135,
    '3677.5': 135, '3680.0': 136, '3682.5': 136, '3685.0': 137, '3687.5': 137,
    '3690.0': 138, '3692.5': 138, '5035': 7, '5040': 8, '5045': 9,
    '5055': 11, '5060': 12, '5080': 16, '5170': 34, '5180': 36,
    '5190': 38, '5200': 40, '5210': 42, '5220': 44, '5230': 46,
    '5240': 48, '5260': 52, '5280': 56, '5300': 60, '5320': 64,
    '5500': 100, '5520': 104, '5540': 108, '5560': 112, '5580': 116,
    '5600': 120, '5620': 124, '5640': 128, '5660': 132, '5680': 136,
    '5700': 140, '5745': 149, '5765': 153, '5785': 157, '5805': 161,
    '5825': 165, '4915': 183, '4920': 184, '4925': 185, '4935': 187, 
    '4940': 188, '4945': 189, '4960': 192, '4980': 196,
}

def f2c(mhz):
    channel = WIFI_FREQUENCIES.get(mhz)
    if channel:
        return channel
    else:
        raise ValueError("could not find channel")
