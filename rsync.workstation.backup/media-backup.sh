#!/bin/bash

function do_media_backup () {
    DST="/Volumes/mediabackup-primary/sneak.media.backups"
    if [[ ! -d $DST ]] ; then
        echo "destination $DST not found, exiting!" > /dev/stderr
        return
    fi

    R="rsync -avP --delete --delete-excluded"

    $R  $HOME/Pictures/LightroomMasters/    $DST/LightroomMasters/
    E=''
    E+=" --exclude='**/Lightroom?Catalog?Previews.lrdata'"
    $R $E   $HOME/Pictures/Lightroom/           $DST/Lightroom/
    E=''
    $R      $HOME/BigDocs/sneak-shot-video/     $DST/sneak-shot-video/
}

do_media_backup

