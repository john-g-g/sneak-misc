#!/bin/bash

# sneak@nostromo-2:~$ ipfs name resolve /ipns/dist.ipfs.io/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# sneak@nostromo-2:~$ ipfs resolve /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmQcKL42JqZtWKjbcCys27iaAKybRcchSFWaD9sF8LEUKL

apt update
apt -y install golang
go get -d github.com/ipfs/ipget
cd $HOME/go/src/github.com/ipfs/ipget
make install
