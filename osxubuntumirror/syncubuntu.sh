#!/bin/bash

set -e

OSX_LOCAL_UBUNTU_MIRROR="${OSX_LOCAL_UBUNTU_MIRROR:-"${HOME}/.local/lib/ubuntumirror"}"
OSX_LOCAL_UBUNTU_SOURCE="${OSX_LOCAL_UBUNTU_SOURCE:-"rsync://ftp.halifax.rwth-aachen.de/ubuntu/"}"

if [[ ! -d "$OSX_LOCAL_UBUNTU_MIRROR" ]]; then
    mkdir -p "$OSX_LOCAL_UBUNTU_MIRROR"
fi

OPTS="-avP --delete --delete-excluded"

RE+=' --exclude /dists/*/main/installer-amd64'
RE+=' --exclude /dists/*/main/uefi'
RE+=' --exclude /dists/*-proposed'
RE+=' --exclude /dists/devel*'
RE+=' --exclude */firefox*'
RE+=' --exclude */openoffice.org*'
RE+=' --exclude */libreoffice*'
RE+=' --exclude */xserver-xorg*'
RE+=' --exclude */xorg-driver*'
RE+=' --exclude /pool/main/*/*/*.gz'
RE+=' --exclude /pool/main/k/kde*'
RE+=' --exclude /pool/main/g/gnome*'
RE+=' --exclude /pool/main/l/language-pack*'
RE+=' --exclude /pool/main/l/linux-ec2'

# need english
RE+=' --include /pool/main/l/language-pack*en*'
RE+=' --include /pool/main/l/language-support*en*'

RE+=" --exclude *.iso"
RE+=" --exclude *i386*"
RE+=' --exclude /pool/universe'

RSYNC="rsync"

if which rsync.3.0.9; then
    RSYNC="rsync.3.0.9"
fi

$RSYNC \
    $OPTS $RE \
    $OSX_LOCAL_UBUNTU_SOURCE \
    $OSX_LOCAL_UBUNTU_MIRROR
