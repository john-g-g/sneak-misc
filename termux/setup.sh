#!/bin/bash

PKGS="
    bash-completion
    byobu
    mosh
    vim
"

apt update
apt -y upgrade
apt -y install $PKGS
