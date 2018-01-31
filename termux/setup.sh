#!/bin/bash

PKGS="
    byobu
    vim
"

apt update
apt -y upgrade
apt -y install $PKGS
