#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

BACKUPHOST=${BACKUPHOST:-"jfk1.datavibe.net"}
SERVERPATH=${SERVERPATH:-backup/}

RSYNC="/usr/bin/rsync"
OPTS="-aPSz --no-owner --no-group --delete-excluded --delete-after"

RE=""
# Dropbox syncs itself just fine:
RE+=" --exclude=/Dropbox/"
RE+=" --exclude=/Library/Safari/"
RE+=" --exclude=/Downloads/" 
RE+=" --exclude=/Library/Application?Support/Ableton/"
# evernote syncs to its server:
RE+=" --exclude=/Library/Application?Support/Evernote/"
RE+=" --exclude=/Library/Application?Support/InsomniaX/"
RE+=" --exclude=/Music/iTunes/Album?Artwork/"
RE+=" --exclude=/Documents/Steam?Content/"
RE+=" --exclude=/tmp/"
RE+=" --exclude=/.Spotlight-V100/"
RE+=" --exclude=/.fseventsd/" 
RE+=" --exclude=/.cpan/build/" 
RE+=" --exclude=/.cpan/sources/" 
RE+=" --exclude=/.Trash/"
RE+=" --exclude=/.Trashes/" 
RE+=" --exclude=/Library/Logs/"
# keep your mail on the server!
RE+=" --exclude=/Library/Mail/"
RE+=" --exclude=/Library/Mail?Downloads/"
RE+=" --exclude=/Library/Application?Support/SecondLife/cache/"
RE+=" --exclude=/Library/Caches/"
RE+=" --exclude=/Library/Developer/Xcode/DerivedData/"
RE+=" --exclude=/Library/iTunes/iPhone?Software?Updates/"
RE+=" --exclude=/Library/iTunes/iPad?Software?Updates/"
RE+=" --exclude=/Pictures/iPod?Photo?Cache/"
RE+=" --exclude=/Library/Application?Support/SyncServices/"
RE+=" --exclude=/Library/Application?Support/MobileSync/"
RE+=" --exclude=/Library/Application?Support/Adobe/Adobe?Device?Central?CS4/"
RE+=" --exclude=/Library/Safari/HistoryIndex.sk"
RE+=" --exclude=/Library/Application?Support/CrossOver?Games/"
RE+=" --exclude=/Library/Preferences/Macromedia/Flash?Player/"
RE+=" --exclude=/Library/PubSub/"
RE+=" --exclude=/Library/Google/"
RE+=" --exclude=/Library/Cookies/"
RE+=" --exclude=/.TemporaryItems/"
RE+=" --exclude=/.rnd/"
RE+=" --exclude=/Receivd/"

MINRE=""
MINRE+=" --exclude=/.fseventsd/"
MINRE+=" --exclude=/.Spotlight-V100/"
MINRE+=" --exclude=/.Trashes/"

# before anything else, backup gpg keys if any:
if [ -d ${HOME}/.gnupg ]; then
    $RSYNC $OPTS -c ${HOME}/.gnupg/ ${BACKUPHOST}:${SERVERPATH}/Home/.gnupg/
fi

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS $RE ${HOME}/ ${BACKUPHOST}:${SERVERPATH}/Home/ 
    RETVAL=$?
        sleep 1;
done

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS $MINRE --exclude=/ApertureScience.sparsebundle/ /Volumes/Storage/ ${BACKUPHOST}:${SERVERPATH}/Storage/ 
    RETVAL=$?
        sleep 1;
done

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS /Applications/ ${BACKUPHOST}:${SERVERPATH}/Applications/ 
    RETVAL=$?
        sleep 1;
done

open /Volumes/Storage/ApertureScience.sparsebundle

if [ -e /Volumes/ApertureScience ]; then
    RETVAL=255
    while [ $RETVAL -ne 0 ]; do
        $RSYNC $OPTS $MINRE /Volumes/ApertureScience/ ${BACKUPHOST}:${SERVERPATH}/ApertureScience/ 
        RETVAL=$?
        sleep 1;
    done
fi

# FIXME todo do some error checking on the non-mountability of the
# ApertureScience volume


