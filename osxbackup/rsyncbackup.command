#!/bin/bash

# mac homedir backup script.
# by jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# see README

NOW="`date +%Y%m%d.%H%M%S`"

BACKUPDEST=${BACKUPDEST:-"/Volumes/ExternalBackup/sneak.backup"}

RSYNC_SKIP_COMPRESS="3fr/3g2/3gp/3gpp/7z/aac/ace/amr/apk/appx/appxbundle/arc/arj/arw"
RSYNC_SKIP_COMPRESS+="/asf/avi/bz2/cab/cr2/crypt[5678]/dat/dcr/deb/dmg/drc/ear"
RSYNC_SKIP_COMPRESS+="/erf/flac/flv/gif/gpg/gz/iiq/iso/jar/jp2/jpeg/jpg/k25/kdc"
RSYNC_SKIP_COMPRESS+="/lz/lzma/lzo/m4[apv]/mef/mkv/mos/mov/mp[34]/mpeg/mp[gv]/msi"
RSYNC_SKIP_COMPRESS+="/nef/oga/ogg/ogv/opus/orf/pef/png/qt/rar/rpm/rw2/rzip/s7z"
RSYNC_SKIP_COMPRESS+="/sfx/sr2/srf/svgz/t[gb]z/tlz/txz/vob/wim/wma/wmv/xz/zip"

RSYNC="$HOME/Library/Homebrew/bin/rsync"
#OPTS="-rlptDPSyzh --numeric-ids --no-owner --no-group --delete-excluded --delete"
OPTS=""
OPTS+=" -avP --skip-compress=$RSYNC_SKIP_COMPRESS"
OPTS+=" --numeric-ids --no-owner --no-group --delete-excluded --delete"

RE=""
RE+=" --exclude=/.minikube/cache/"
RE+=" --exclude=/.docker/"
RE+=" --exclude=.cache/"
RE+=" --exclude=.bundle/"
RE+=" --exclude=/Desktop/" # desktop is like a visible tempdir.
RE+=" --exclude=/Library/Safari/"
RE+=" --exclude=/Downloads/"
RE+=" --exclude=/Library/Application?Support/Ableton/"
# evernote syncs to its server:
RE+=" --exclude=/Library/Application?Support/Evernote/"
RE+=" --exclude=/Library/Application?Support/InsomniaX/"
RE+=" --exclude=/Music/iTunes/Album?Artwork/"
RE+=" --exclude=/Documents/Steam?Content/"
RE+=" --exclude=/.dropbox/"
RE+=" --exclude=/Documents/Dropbox/.dropbox.cache/"
RE+=" --exclude=/.cpan/build/"
RE+=" --exclude=/.cpan/sources/"
RE+=" --exclude=/Library/Logs/"
# keep your mail on the server!
RE+=" --exclude=/Library/Mail/"
RE+=" --exclude=/Library/Mail?Downloads/"
RE+=" --exclude=/Library/Application?Support/SecondLife/cache/"
RE+=" --exclude=/Library/Caches/"
RE+=" --exclude=/Library/Developer/Xcode/DerivedData/"
RE+=" --exclude=/Library/Developer/Shared/Documentation/"
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
RE+=" --exclude=/Library/Cookies/"
RE+=" --exclude=/Library/Preferences/SDMHelpData/"
RE+=" --exclude=/Receivd/"
RE+=" --exclude=/Library/Application?Support/Steam/SteamApps/"
RE+=" --exclude=/VirtualBox?VMs/"

# apps in homedir
RE+=" --exclude=/Applications/Fortnite/"

MINRE=""
MINRE+=" --exclude=/.fseventsd/"
MINRE+=" --exclude=/.Spotlight-V100/"
MINRE+=" --exclude=/.Trash/"
MINRE+=" --exclude=/.Trashes/"
MINRE+=" --exclude=/tmp/"
MINRE+=" --exclude=/.TemporaryItems/"
MINRE+=" --exclude=/.rnd/"
MINRE+=" --exclude=.DS_Store"

RE+=" ${MINRE}"

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS $RE ${HOME}/ ${BACKUPDEST}/home.$(whoami)/
    RETVAL=$?
    sleep 1;
done


RE=""
RE+=" --exclude=/.DS_Store"
RE+=" --exclude=/App?Store.app"
RE+=" --exclude=/Automator.app"
RE+=" --exclude=/Books.app"
RE+=" --exclude=/Calculator.app"
RE+=" --exclude=/Calendar.app"
RE+=" --exclude=/Chess.app"
RE+=" --exclude=/Contacts.app"
RE+=" --exclude=/DVD?Player.app"
RE+=" --exclude=/Dashboard.app"
RE+=" --exclude=/Dictionary.app"
RE+=" --exclude=/FaceTime.app"
RE+=" --exclude=/Font?Book.app"
RE+=" --exclude=/Game?Center.app"
RE+=" --exclude=/GarageBand.app"
RE+=" --exclude=/Home.app"
RE+=" --exclude=/Image?Capture.app"
RE+=" --exclude=/Install?OS?X?El?Capitan.app"
RE+=" --exclude=/Install?OS?X?Yosemite.app"
RE+=" --exclude=/Keynote.app"
RE+=" --exclude=/Launchpad.app"
RE+=" --exclude=/Mail.app"
RE+=" --exclude=/Maps.app"
RE+=" --exclude=/Messages.app"
RE+=" --exclude=/Mission?Control.app"
RE+=" --exclude=/News.app"
RE+=" --exclude=/Notes.app"
RE+=" --exclude=/Numbers.app"
RE+=" --exclude=/Pages.app"
RE+=" --exclude=/Photo?Booth.app"
RE+=" --exclude=/Photos.app"
RE+=" --exclude=/Preview.app"
RE+=" --exclude=/QuickTime?Player.app"
RE+=" --exclude=/Reminders.app"
RE+=" --exclude=/Safari.app"
RE+=" --exclude=/Siri.app"
RE+=" --exclude=/Spotify.app"
RE+=" --exclude=/Steam.app"
RE+=" --exclude=/Stickies.app"
RE+=" --exclude=/System?Preferences.app"
RE+=" --exclude=/TextEdit.app"
RE+=" --exclude=/Time?Machine.app"
RE+=" --exclude=/Utilities/Activity?Monitor.app"
RE+=" --exclude=/Utilities/AirPort?Utility.app"
RE+=" --exclude=/Utilities/AppleScript?Editor.app"
RE+=" --exclude=/Utilities/Audio?MIDI?Setup.app"
RE+=" --exclude=/Utilities/Bluetooth?File?Exchange.app"
RE+=" --exclude=/Utilities/Boot?Camp?Assistant.app"
RE+=" --exclude=/Utilities/ColorSync?Utility.app"
RE+=" --exclude=/Utilities/Console.app"
RE+=" --exclude=/Utilities/Digital?Color?Meter.app"
RE+=" --exclude=/Utilities/DigitalColor?Meter.app"
RE+=" --exclude=/Utilities/Disk?Utility.app"
RE+=" --exclude=/Utilities/Grab.app"
RE+=" --exclude=/Utilities/Grapher.app"
RE+=" --exclude=/Utilities/Keychain?Access.app"
RE+=" --exclude=/Utilities/Migration?Assistant.app"
RE+=" --exclude=/Utilities/Screenshot.app"
RE+=" --exclude=/Utilities/Script?Editor.app"
RE+=" --exclude=/Utilities/System?Information.app"
RE+=" --exclude=/Utilities/Terminal.app"
RE+=" --exclude=/Utilities/VoiceOver?Utility.app"
RE+=" --exclude=/VirtualBox.app"
RE+=" --exclude=/VoiceMemos.app"
RE+=" --exclude=/Xcode.app"
RE+=" --exclude=/iBooks.app"
RE+=" --exclude=/iMovie.app"
RE+=" --exclude=/iTunes.app"

RETVAL=255
while [ $RETVAL -ne 0 ]; do
    $RSYNC $OPTS $RE $MINRE /Applications/ ${BACKUPDEST}/Applications/
    RETVAL=$?
    sleep 1;
done
