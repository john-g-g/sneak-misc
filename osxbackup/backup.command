#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

BACKUPDEST=${BACKUPDEST:-"sftp://sneak@datavibe.net/backup"}

PASSPHRASEFILE="${HOME}/Documents/Secure/backup-password.txt"
export PASSPHRASE="$(cat $PASSPHRASEFILE)"

OPTS+=" -v 5"
OPTS+=" --exclude-globbing-filelist ${HOME}/.local/etc/duplicity.exclude"
#OPTS+=" --asynchronous-upload"
#OPTS+=" --allow-source-mismatch"
#GPGOPTS="--compress-algo=bzip2 --bzip2-compress-level=9"

if [ "$1" == "--verify" ]; then
    time \
        duplicity --gpg-options '$GPGOPTS' \
            verify $OPTS $BACKUPDEST ${HOME}/
else 
    time \
        duplicity --gpg-options "$GPGOPTS" \
            $EXTRADUPLICITY $OPTS $RE ${HOME}/ $BACKUPDEST
        echo "attempted backup to $BACKUPDEST"
    if [ $? ]; then
        echo "backup failed!" > /dev/stderr
        exit 127
    else    
        echo "Successfully completed backup to ${BACKUPDEST}."
    fi
fi
