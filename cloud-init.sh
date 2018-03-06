#!/bin/sh

# fetch and run this in cloud-init, viz:

##cloud-config
#runcmd:
#  - curl -fsSL https://raw.githubusercontent.com/sneak/hacks/master/cloud-init.sh | bash

#exec 1 2>&1 | tee -a ${LOG_FILE}

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install vim byobu screen build-essential git mosh bash-completion golang-go python-pip python3-pip

pip3 install --upgrade pip

pip3 install awscli pipenv aws-shell

curl -L https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

# create user if doesn't exist
if [[ ! -d /home/sneak ]]; then
    useradd -m -s /bin/bash sneak
    usermod -a -G sudo sneak
    echo "sneak ALL=NOPASSWD:ALL" > /etc/sudoers.d/sneak
fi

# run the rest as sneak:
sudo -H -u sneak bash <<EOF

export HOME=/home/sneak

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

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install node

mkdir -p ~/.local/bashrc.d
mkdir -p ~/.local/profile.d

mv ~/.profile ~/.local/profile.d/999.distro.profile.sh
mv ~/.bashrc ~/.local/bashrc.d/999.distro.bashrc.sh

rsync -avP /home/sneak/hacks/homedir.skel/ /home/sneak/
EOF
