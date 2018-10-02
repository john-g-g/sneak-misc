#!/bin/bash

# sneak@nostromo-2:~$ ipfs name resolve /ipns/dist.ipfs.io/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# sneak@nostromo-2:~$ ipfs resolve /ipfs/QmUDECZXueqXdcBEu3SLf8J19QfubhksdrDZeh1exCVMDz/ipget/v0.3.0/ipget_v0.3.0_linux-amd64.tar.gz
# /ipfs/QmQcKL42JqZtWKjbcCys27iaAKybRcchSFWaD9sF8LEUKL

if [[ $(arch) = "x86_64" ]]; then
    HASH="QmQcKL42JqZtWKjbcCys27iaAKybRcchSFWaD9sF8LEUKL"
    curl -f https://cloudflare-ipfs.com/ipfs/$HASH > \
            /tmp/ipget_v0.3.0_linux.amd64.tar.gz && \
    cd /tmp && \
    tar zxvf ./ipget_v0.3.0_linux.amd64.tar.gz && \
    mv ipget/ipget /usr/local/bin/ipget
fi
