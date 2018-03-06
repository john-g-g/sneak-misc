#!/bin/bash

# fetch and run this in cloud-init, viz:

##cloud-config
#runcmd:
#  - curl -fsSL https://raw.githubusercontent.com/sneak/hacks/master/provision.workbox/cloud-init.sh | bash

# make sure we don't OOM
if [[ ! -e /var/swapfile ]]; then
    fallocate -l 2G /var/swapfile
    chmod 600 /var/swapfile
    mkswap /var/swapfile
    echo '/var/swapfile none swap sw 0 0' | tee -a /etc/fstab
fi
swapon /var/swapfile

echo 'vm.swappiness=80' >> /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
sysctl -p

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install git
git clone https://github.com/sneak/hacks.git /var/tmp/hacks
cd /var/tmp/hacks/provision.workbox
bash main.sh
