#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

BACKUPDEST=${BACKUPDEST:-"${USER}@jfk1.datavibe.net:backup/"}

RSYNC="/usr/bin/rsync"
OPTS="-aPSz --no-owner --no-group --delete-excluded --delete-after"

RE=""
# Dropbox syncs itself just fine:
RE+=" --exclude=/Dropbox/"
RE+=" --exclude=/Desktop/" # desktop is like a visible tempdir.
RE+=" --exclude=/Library/Safari/"
RE+=" --exclude=/Downloads/" 
RE+=" --exclude=/Library/Application?Support/Ableton/"
# evernote syncs to its server:
RE+=" --exclude=/Library/Application?Support/Evernote/"
RE+=" --exclude=/Library/Application?Support/InsomniaX/"
RE+=" --exclude=/Music/iTunes/Album?Artwork/"
RE+=" --exclude=/Documents/Steam?Content/"
RE+=" --exclude=/.cpan/build/" 
RE+=" --exclude=/.cpan/sources/" 
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
# just say no to skynet
RE+=" --exclude=/Library/Google/"
RE+=" --exclude=/Library/Cookies/"
RE+=" --exclude=/Receivd/"

MINRE=""
MINRE+=" --exclude=/.fseventsd/"
MINRE+=" --exclude=/.Spotlight-V100/"
MINRE+=" --exclude=/.Trash/"
MINRE+=" --exclude=/.Trashes/"
MINRE+=" --exclude=/tmp/"
MINRE+=" --exclude=/.TemporaryItems/"
MINRE+=" --exclude=/.rnd/"

RE+=" ${MINRE}"

# before anything else, backup gpg keys if any:
if [ -d ${HOME}/.gnupg ]; then
    $RSYNC $OPTS -c ${HOME}/.gnupg/ ${BACKUPDEST}/Home/.gnupg/
fi

# high priority stuff first:
if [ -d ${HOME}/Development ]; then
    $RSYNC $OPTS -c ${HOME}/Development/ \
        ${BACKUPDEST}/Home/Development/
fi

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS $RE ${HOME}/ ${BACKUPDEST}/Home/ 
    RETVAL=$?
        sleep 1;
done

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS /Applications/ ${BACKUPDEST}/Applications/ 
    RETVAL=$?
        sleep 1;
done

