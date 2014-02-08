#!/bin/bash

set -e

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

BACKUPDEST=${BACKUPDEST:-"sftp://sneak@datavibe.net/backup"}

PASSPHRASEFILE="${HOME}/Documents/Secure/backup-password.txt"
if [ -r "$PASSPHRASEFILE" ]; then
    export PASSPHRASE="$(cat $PASSPHRASEFILE)"
else
    echo "$0 error: unable to read passphrase from file!" > /dev/stderr
    exit 127
fi

OPTS=""
OPTS+=" -v 5"
OPTS+=" --volsize 100"
#OPTS+=" --asynchronous-upload"
#OPTS+=" --allow-source-mismatch"

EXTRA=" --exclude-globbing-filelist ${HOME}/.local/etc/duplicity.exclude"
EXTRA+=" --exclude ${HOME}/Pictures/Aperture?Library.aplibrary"
EXTRA+=" --exclude ${HOME}/Documents/Dropbox"
SRC="${HOME}"
duplicity $DUPLICITY_ARGS $EXTRA $OPTS $RE $SRC $BACKUPDEST/home/

SRC="${HOME}/Pictures/Aperture?Library.aplibrary"
EXTRA=""
EXTRA+=" --exclude $SRC/Thumbnails"
EXTRA+=" --exclude $SRC/Previews"
duplicity $DUPLICITY_ARGS $EXTRA $OPTS $RE $SRC $BACKUPDEST/aperture/

EXTRA=""
SRC="${HOME}/Documents/Dropbox"
duplicity $DUPLICITY_ARGS $EXTRA $OPTS $RE $SRC $BACKUPDEST/dropbox/

EXTRA="
    --exclude-globbing-filelist
    ${HOME}/.local/etc/duplicity.applications.exclude
"
SRC="/Applications"
duplicity $DUPLICITY_ARGS $EXTRA $OPTS $RE $SRC $BACKUPDEST/apps/
