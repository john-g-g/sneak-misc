#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

#RBACKUPDEST=${RBACKUPDEST:-"file:///Volumes/TImeMachine/sneakbackup/"}
#RBACKUPDEST=${RBACKUPDEST:-"sftp://sneak@datavibe.net/backup"}
RBACKUPDEST=${RBACKUPDEST:-"file:///Volumes/EXTUSB01/dup/"}
#RBACKUPDEST=${RBACKUPDEST:-"file:///Volumes/EXTUSB02/dup/"}

#OPTS="--encrypt-sign-key 1921C0F4"
OPTS+=" -v 5"
OPTS+=" --exclude-globbing-filelist ${HOME}/.local/etc/duplicity.exclude"
OPTS+=" --volsize 1024"
OPTS+=" --asynchronous-upload"
OPTS+=" --allow-source-mismatch"

if [ "$1" == "--verify" ]; then
    duplicity verify $OPTS $RBACKUPDEST ${HOME}/
else 
    duplicity $EXTRADUPLICITY $OPTS $RE ${HOME}/ $RBACKUPDEST
fi
