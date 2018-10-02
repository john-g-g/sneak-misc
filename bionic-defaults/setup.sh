#!/bin/bash

apt update
apt -y install lsb-release

PKGS="
    apt-transport-https
    bash-completion
    build-essential
    byobu
    command-not-found
    cryptsetup-bin
    daemontools
    iptables-persistent
    iptraf-ng
    jq
    less
    lsof
    mosh
    pbzip2
    pv
    runit
    runit-systemd
    socat
    vim
    wget
    zfs-auto-snapshot
    zfsutils-linux
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
