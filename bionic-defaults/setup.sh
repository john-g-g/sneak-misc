#!/bin/bash

apt update
apt -y install lsb-release

PKGS="
    apt-transport-https
    byobu
    command-not-found
    cryptsetup-bin
    iptraf-ng
    jq
    less
    lsof
    runit
    runit-systemd
    daemontools
    vim
    wget
    pv
    pbzip2
    zfsutils-linux
    zfs-auto-snapshot
"

MRUM="main restricted universe multiverse"
URL="mirror://mirrors.ubuntu.com/mirrors.txt"

cat > /etc/apt/sources.list <<__EOF__
deb $URL $(lsb_release -cs)             $MRUM
deb $URL $(lsb_release -cs)-updates     $MRUM
deb $URL $(lsb_release -cs)-backports   $MRUM
deb $URL $(lsb_release -cs)-security    $MRUM
__EOF__

export DEBIAN_FRONTEND=noninteractive
apt update
apt -y install $PKGS

rm -rf /var/lib/apt/lists/*
