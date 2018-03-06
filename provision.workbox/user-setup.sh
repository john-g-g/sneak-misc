#!/bin/bash
export HOME=/home/sneak

# install python3 packages
pip3 install --user awscli awsebcli virtualenv pipenv aws-shell

# install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install node

if [[ ! -d ~/.ssh ]]; then
    mkdir -p ~/.ssh
fi

if [[ ! -e ~/.ssh/sneak.keys ]]; then
    cd ~/.ssh && \
    wget https://github.com/sneak.keys && \
    cat *.keys > authorized_keys
fi

if [[ ! -d ~/hacks ]]; then
    cd ~
    git clone https://github.com/sneak/hacks.git
fi
mkdir -p ~/.local/bashrc.d
mkdir -p ~/.local/profile.d

mv ~/.profile ~/.local/profile.d/000.distro.profile.sh
mv ~/.bashrc ~/.local/bashrc.d/000.distro.bashrc.sh

rsync -avP /home/sneak/hacks/homedir.skel/ /home/sneak/
