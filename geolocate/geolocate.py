#!/usr/bin/env python

import requests
import subprocess
import sys
import json
import re
import time
import datetime
import os

def main():
    ts = int(datetime.datetime.now().strftime("%s"))
    loc = geolocate(wifidata=listAccessPoints())
    loc['timestamp'] = ts
    loc = json.dumps(loc)
    path = os.path.expanduser('~/.data/location')
    writeFile(os.path.join(path, 'latest.json'), loc)
    writeFile(os.path.join(path, "%i.json" % ts), loc)

def writeFile(fn,content):
    with open(fn,'w') as f:
        f.write(content)

def geolocate(wifidata=None):
    url = "https://location.services.mozilla.com/v1/geolocate?key=test"
    postdata = { }
    if wifidata:
        postdata['wifiAccessPoints'] = wifidata
    return requests.post(url, data=json.dumps(postdata)).json()

def listAccessPoints():
    bssids = []
    cmd = "nmcli -t d list".split(' ')
    output = subprocess.check_output(cmd)
    for line in output.split('\n'):
        m = re.match('AP\[\d+\]\.BSSID\:(\S+)',line)
        if m:
            bssids.append(m.group(1))
    if len(bssids) < 2:
        return None
    return [ {'macAddress': x} for x in bssids ]

sys.exit(main())
