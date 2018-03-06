#!/bin/bash

# fetch and run this in cloud-init, viz:

##cloud-config
#runcmd:
#  - curl -fsSL https://raw.githubusercontent.com/sneak/hacks/master/provision.workbox/cloud-init.sh | bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install git
git clone https://github.com/sneak/hacks.git /var/tmp/hacks
cd /var/tmp/hacks/provision.workbox
bash main.sh
