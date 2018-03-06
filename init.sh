#!/bin/sh

# fetch and run this in cloud-init, viz:

##cloud-config
#runcmd:
#  - curl -fsSL https://raw.githubusercontent.com/sneak/hacks/master/init.sh | bash
  
#exec 1 2>&1 | tee -a ${LOG_FILE}

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install vim byobu screen build-essential git

if [[ ! -d /home/sneak ]]; then
    useradd -m sneak
    usermod -a -G sudo sneak
fi

# run the rest as sneak:
sudo -H -u sneak bash <<EOF

if [[ ! -d /home/sneak/.ssh ]]; then
    mkdir -p /home/sneak/.ssh
fi

if [[ ! -e /home/sneak/.ssh/sneak.keys ]]; then
    cd /home/sneak/.ssh && \
    wget https://github.com/sneak.keys && \
    cat *.keys > authorized_keys
fi

if [[ ! -d /home/sneak/hacks ]]; then
    cd /home/sneak
    git clone https://github.com/sneak/hacks.git
fi

rsync -avP /home/sneak/hacks/homedir.skel/ /home/sneak/

EOF
