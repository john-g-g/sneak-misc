#!/bin/bash

PKGS="
    bash-completion
    build-essential
    byobu
    command-not-found
    cryptsetup-bin
    daemontools
    golang-go
    iptables-persistent
    iptraf-ng
    jq
    less
    lsof
    mosh
    ntp
    pbzip2
    pv
    runit
    runit-systemd
    socat
    vim
    wget
"

export DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo apt install -y $PKGS
