#!/usr/bin/python

import json
import urllib2
import pprint
import time
import sys

def main():
    urlbase = 'https://mtgox.com/code/data/getTrades.php'
    running = True
    tid = 0
    out = []
    while running:
        #time.sleep(1)        
        derp = getjsonurl("%s?since=%i" % (urlbase, tid))
        for tx in derp:
            for field in ('tid', 'date'):
                tx[field] = int(tx[field])
            tx['price'] = float(tx['price'])
            if tx['tid'] > tid:
                tid = tx['tid']
            sys.stderr.write("%i,%f\n" % (tx['date'],tx['price']))
            out.append(tx)
            if tid >= 1313122176592047:
                running = False
    print json.dumps(out)

def getjsonurl(url):
    return json.loads(urllib2.urlopen(url).read())

main()

