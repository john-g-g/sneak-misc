#!/usr/bin/python2.6

import urllib
import sys
import json
import decimal

def main(argv):
    current = fetch_mtgox_orders()

def fetch_mtgox_orders():
    url = 'https://mtgox.com/code/data/getDepth.php'
    parsed = json.loads(
        urllib.urlopen(url).read(),
        parse_float=decimal.Decimal
    )
    print repr(parsed)

sys.exit(main(sys.argv))
