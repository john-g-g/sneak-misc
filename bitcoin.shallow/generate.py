#!/usr/bin/python2.6
# this script has been totally obsoleted by mtgoxlive.com
# written by coderrr

import urllib
import sys
import json
import decimal

def main(argv):
    current = fetch_mtgox_orders()

    selling = selling_stats(current['bids'])
    buying = buying_stats(current['asks'])


def selling_stats(bids):
    high = max([bid[0] for bid in bids])
    low = min([bid[0] for bid in bids])
    print "highbid %s" % high
    print "lowbid %s" % low

def buying_stats(asks):
    pass

def fetch_mtgox_orders():
    url = 'https://mtgox.com/code/data/getDepth.php'
    parsed = json.loads(
        urllib.urlopen(url).read(),
        parse_float=decimal.Decimal
    )
    return parsed

sys.exit(main(sys.argv))
