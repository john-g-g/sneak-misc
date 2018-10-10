#!/bin/bash

apt update
apt upgrade -y
apt install -y docker.io byobu
byobu-enable

mkdir -p /var/lib/ubuntumirror /var/lib/ipfs

docker rmi -f sneak/ipfs-ubuntu-mirror:latest
docker run -d \
        -p 4001:4001 \
        -p 4002:4002/udp \
        -p 5001:5001 \
        -p 8080:8080 \
        -p 8081:8081 \
        -v /var/lib/ubuntumirror:/var/lib/ubuntumirror \
        -v /var/lib/ipfs:/var/lib/ipfs \
        --env UBUNTU_MIRROR_SOURCE=nyc1.mirrors.digitalocean.com \
        sneak/ipfs-ubuntu-mirror:latest

