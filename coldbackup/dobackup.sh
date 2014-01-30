#!/bin/bash

set -e

export DESTDIR="/Volumes/coldbackup"

if [ ! -d "$DESTDIR" ]; then
    echo "dest disk $DESTDIR not present" > /dev/stderr
    exit 127
fi

vagrant destroy -f || true # FIXME this may cause disk corruption

PASSPHRASEFILE="${HOME}/Documents/Secure/backup-password.txt"
export BACKUP_ENCRYPTION_KEY="$(cat "$PASSPHRASEFILE")"
vagrant up
