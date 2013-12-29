#!/bin/bash

EX=""
EX+=" --exclude=.DS_Store"
EX+=" --exclude=/iBooks.app/"
EX+=" --exclude=/iTunes.app/"
EX+=" --exclude=/FaceTime.app/"
EX+=" --exclude=/Calendar.app/"
EX+=" --exclude=/Mail.app/"
EX+=" --exclude=/QuickTime?Player.app/"
EX+=" --exclude=/Safari.app/"
EX+=" --exclude=/Preview.app/"
EX+=" --exclude=/Notes.app/"
EX+=" --exclude=/TextEdit.app/"
EX+=" --exclude=/Photo?Booth.app/"
EX+=" --exclude=/Game?Center.app/"
EX+=" --exclude=/Calculator.app/"
EX+=" --exclude=/Chess.app/"
EX+=" --exclude=/Dictionary.app/"
EX+=" --exclude=/Image?Capture.app/"
EX+=" --exclude=/System?Preferences.app/"
EX+=" --exclude=/DVD?Player.app/"
EX+=" --exclude=/Stickies.app/"
EX+=" --exclude=/Time?Machine.app/"
EX+=" --exclude=/Mission?Control.app/"
EX+=" --exclude=/Dashboard.app/"
EX+=" --exclude=/Launchpad.app/"
EX+=" --exclude=/Contacts.app/"
EX+=" --exclude=/Maps.app/"
EX+=" --exclude=/App?Store.app/"
EX+=" --exclude=/Reminders.app/"
EX+=" --exclude=/Automator.app/"
EX+=" --exclude=/Font?Book.app/"
EX+=" --exclude=/Messages.app/"
EX+=" --exclude=/Utilities/Activity?Monitor.app/"
EX+=" --exclude=/Utilities/AirPort?Utility.app/"
EX+=" --exclude=/Utilities/AppleScript?Editor.app/"
EX+=" --exclude=/Utilities/Audio?MIDI?Setup.app/"
EX+=" --exclude=/Utilities/Bluetooth?File?Exchange.app/"
EX+=" --exclude=/Utilities/Boot?Camp?Assistant.app/"
EX+=" --exclude=/Utilities/ColorSync?Utility.app/"
EX+=" --exclude=/Utilities/Console.app/"
EX+=" --exclude=/Utilities/DigitalColor?Meter.app/"
EX+=" --exclude=/Utilities/Disk?Utility.app/"
EX+=" --exclude=/Utilities/Grab.app/"
EX+=" --exclude=/Utilities/Grapher.app/"
EX+=" --exclude=/Utilities/Keychain?Access.app/"
EX+=" --exclude=/Utilities/Migration?Assistant.app/"
EX+=" --exclude=/Utilities/System?Information.app/"
EX+=" --exclude=/Utilities/Terminal.app/"
EX+=" --exclude=/Utilities/VoiceOver?Utility.app/"
EX+=" --exclude=/VirtualBox.app/" #useless without kexts

DEST="sneak@ber1.local:backup/Applications.20131229"

rsync -avP --delete --delete-excluded $EX \
    /Applications/ $DEST/
