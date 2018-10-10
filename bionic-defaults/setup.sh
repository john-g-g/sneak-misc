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

# install ipget v0.3.0 amd64:
# sneak@nostromo-2:~$ ipfs name resolve /ipns/dist.ipfs.io/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# sneak@nostromo-2:~$ ipfs resolve /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmQcKL42JqZtWKjbcCys27iaAKybRcchSFWaD9sF8LEUKL
HASH="QmQcKL42JqZtWKjbcCys27iaAKybRcchSFWaD9sF8LEUKL"
if [[ "$(arch)" = "x86_64" ]]; then
    if [[ ! -x /usr/local/bin/ipget ]]; then
        curl -f https://cloudflare-ipfs.com/ipfs/$HASH > /tmp/ipget_v0.3.0_linux.amd64.tar.gz && \
        cd /tmp && \
        tar zxvf ./ipget_v0.3.0_linux.amd64.tar.gz && \
        mv ipget/ipget /usr/local/bin/ipget && \
        chmod +x /usr/local/bin/ipget
    fi
fi
