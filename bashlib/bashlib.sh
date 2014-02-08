#!/bin/bash

set -e

function onOSX () {
    return [[ $(uname) == "Darwin" ]]
}

function findLocalService () {

    local SVC="$1"

    if onOSX; then
        local OUT="$(
            echo -e "spawn -noecho dns-sd -Z $SVC\nexpect -timeout 1 eof {}" | 
            expect -f - |
            grep SRV | egrep -v '^\s*;'
        )"
        local PORT="$(echo $OUT | awk '{print $5}')"
        local HOST="$(echo $OUT | awk '{print $6}')"
    else
        # linux only for now
        local OUT="$(avahi-browse -p -t -r $SVC | grep '^=' | head -1)"
        local NAME="$(echo \"$AL\" | cut -d';' -f 8)"
        local PORT="$(echo \"$AL\" | cut -d';' -f 9)"
    fi

    echo $HOST:$PORT
}
