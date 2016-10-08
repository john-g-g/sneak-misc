#!/bin/bash

set -x

LOCFILE="$HOME/.location.json"
IP_REGEX='((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'

URL="http://freegeoip.net/json/"


if [[ -e $LOCFILE ]]; then
    LOCFILE_AGE=$(($(date +%s) - $(date -r "$LOCFILE" +%s)))
else
    LOCFILE_AGE=999999
fi

if [[ $LOCFILE_AGE -gt 21600 ]]; then #6h
    UPDATE=1
else
    UPDATE=0
fi

if [[ $UPDATE -eq 0 ]]; then
    exit 0
fi

#CUR_IP=$(curl -sq http://checkip.dyndns.org | grep -oE $IP_REGEX)
#echo "CUR_IP=$CUR_IP" > $LOCFILE.new

curl -fsSL https://freegeoip.net/json > $LOCFILE.new && \
    mv $LOCFILE.new $LOCFILE && \
    jq . $LOCFILE
