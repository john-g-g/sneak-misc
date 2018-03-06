#!/bin/bash
PKGS="
    bash-completion
    byobu
    git
    mosh
    vim
"

apt update
apt -y upgrade
apt -y install $PKGS
apt -y autoremove

git config --global user.email jp@eeqj.com
git config --global user.name "Jeffrey Paul"
