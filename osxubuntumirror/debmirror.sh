#!/bin/bash

export GNUPGHOME="${HOME}/.local/etc/debmirror/keyring"
mkdir -p "$GNUPGHOME"
gpg --no-default-keyring \
    --keyring $GNUPGHOME/trustedkeys.gpg \
    --import ./ubuntu-archive-keyring.gpg

debmirror \
    --ignore-small-errors \
    -a amd64 \
    --verbose \
    --no-source \
    -s main,restricted \
    -h ber1.local \
    -d precise,precise-updates,precise-security \
    -d quantal,quantal-updates,quantal-security \
    -d raring,raring-updates,raring-security \
    -d saucy,saucy-updates,saucy-security \
    -d trusty,trusty-updates,trusty-security \
    --exclude-deb-section=kde \
    --exclude-deb-section=gnome \
    --exclude-deb-section=x11 \
    --exclude-deb-section=unity \
    --exclude-deb-section=games \
    --exclude='/android' \
    --exclude='/brother-*' \
    --exclude='/aspell-(?!en)' \
    --exclude='/asterisk-core-sounds-(?!en)' \
    --exclude='/asterisk-prompt-(?!en)' \
    --exclude='/nvidia*' \
    --exclude='/bcmwl*' \
    --exclude='/fglrx*' \
    --exclude='/thunderbird*' \
    --exclude='/libreoffice*' \
    --exclude='/linux-signed*' \
    --exclude='/linux-doc*' \
    --exclude='/kde*' \
    --exclude='/firefox*' \
    --exclude='/gnome*' \
    --exclude='/libgnome*' \
    --exclude='/language-pack-(?!en)' \
    --exclude='-dbg_*' \
    -r /ubuntu \
    --progress \
    -e http \
    $OSX_LOCAL_UBUNTU_MIRROR
