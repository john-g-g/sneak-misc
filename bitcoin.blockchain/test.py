#!/usr/bin/python2.6

import sys
import bsddb

bitcoin_dir = "%s/Library/Application Support/Bitcoin/" % os.environ['HOME']

def main(argv):
    d = bsddb.btopen("%s/blkindex.dat" % bitcoin_dir)

    print d.keys()

sys.exit(main(sys.argv))

