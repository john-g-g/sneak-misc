#!/bin/bash

# don't actually use this, it hammers the server unnecessarily.
# use jgarzik's getblock patch @
# http://gtf.org/garzik/bitcoin/patch.bitcoin-getblock

exit 1

x=1

while true; do
    B=`wget -O - http://blockexplorer.com/b/$x | grep keywor | \
        awk -F, '{print $6}' | tr -d "\"> "`
    if [ ! -e $x.json ]; then
        wget -O $x.json http://blockexplorer.com/rawblock/$B
    fi
    x=$(( $x + 1 ))
done
