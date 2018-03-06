#!/bin/sh

# run as root

apt-get update
apt-get -y upgrade
apt-get -y install vim byobu screen build-essential

if [[ ! -d /home/sneak ]]; then
    mkdir -p /home/sneak
    chown sneak:sneak /home/sneak
fi

if [[ ! -d /home/sneak/.ssh ]]; then
    mkdir -p /home/sneak/.ssh
    chown sneak:sneak /home/sneak/.ssh
fi

if [[ ! -e /home/sneak/.ssh/sneak.keys ]]; then
    cd /home/sneak/.ssh && \
    wget https://github.com/sneak.keys && \
    mv authorized_keys authorized-keys-orig.keys && \
    cat *.keys > authorized_keys
    chown sneak:sneak *
fi
