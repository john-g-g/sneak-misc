#!/bin/bash

BACKUPS=""

for B in ls ~/Library/Application\ Support/MobileSync/Backup/* ; do
    BACKUPS+=" $(basename "$B")"
done

if [ -r ${HOME}/Documents/Secure/iphone-backup-password.sh ]; then
    source "${HOME}/Documents/Secure/iphone-backup-password.sh"
fi

# expecting $IPHONE_BACKUP_PASSWORD to be set now. set it in your
# environment if not, or put a script exporting it at that path above

echo $BACKUPS

WORKDIR="$TMPDIR/iphone-sms-dump.workd"
if [ ! -d "$WORKDIR" ]; then
    mkdir -p "$WORKDIR"
fi

for BID in $BACKUPS ; do
    if [ ! -r $WORKDIR/sms-$BID.db ]; then
        TD="$(mktemp -d -t bdir)/out"
        echo -e "y\n$IPHONE_BACKUP_PASSWORD" |
        python ./iphone-dataprotection/python_scripts/backup_tool.py \
            "${HOME}/Library/Application Support/MobileSync/Backup/$BID" \
            "$TD" 2>&1 > /dev/null # hush
        echo "extracted to $TD"
        mv "$TD/HomeDomain/Library/SMS/sms.db" ./sms-$BID.db
        mv "$TD/MediaDomain/Library/SMS/Attachments" ./Attachments-$BID.d
        rm -rf "$TD"
    fi
done

for BID in $BACKUPS ; do
    # now we process them...
done
