#!/bin/bash
#exec 1 2>&1 | tee -a ${LOG_FILE}

if which lsb_release; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -y upgrade
    apt-get -y install $(cat $(lsb_release -i -s)-$(lsb_release -r -s)-packages.txt)
fi

pip3 install --upgrade pip

URLBASE="https://github.com/docker/machine/releases/download/v0.14.0"
URL="$URLBASE/docker-machine-$(uname -s)-$(uname -m)"
curl -L $URL > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

if [[ ! -d /home/sneak ]]; then
    useradd -m -s /bin/bash sneak
    usermod -a -G sudo sneak
    echo "sneak ALL=NOPASSWD:ALL" > /etc/sudoers.d/sneak
fi

# run the rest as sneak:
sudo -H -u sneak bash user-setup.sh
