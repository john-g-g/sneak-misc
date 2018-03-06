#!/bin/bash

# install with the following:

# pkg install curl
# curl -fsSL https://raw.githubusercontent.com/sneak/hacks/master/termux/setup.sh | bash

PKGS="
    bash-completion
    byobu
    curl
    git
    golang
    mosh
    vim
    wget
    proot
"

apt update
apt -y upgrade
apt -y install $PKGS
apt -y autoremove

git config --global user.email jp@eeqj.com
git config --global user.name "Jeffrey Paul"

