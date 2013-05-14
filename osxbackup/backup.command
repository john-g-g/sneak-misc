#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

#RBACKUPDEST=${RBACKUPDEST:-"sftp://sneak@datavibe.net/backup"}
RBACKUPDEST=${RBACKUPDEST:-"file:///Volumes/EXTUSB01/dup/"}

#OPTS="--encrypt-sign-key 1921C0F4"
OPTS+=" -v 5"
OPTS+=" --exclude-globbing-filelist ${HOME}/.local/etc/duplicity.exclude"
OPTS+=" --volsize 256"
OPTS+=" --asynchronous-upload"
duplicity $OPTS $RE ${HOME}/ $RBACKUPDEST
