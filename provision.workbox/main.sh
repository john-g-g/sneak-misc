#!/bin/bash
#exec 1 2>&1 | tee -a ${LOG_FILE}

if which lsb_release; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -y upgrade
    apt-get -y install $(cat $(lsb_release -i -s)-$(lsb_release -r -s)-packages.txt)

    # install kubectl
    snap install kubectl --classic
fi

pip3 install --upgrade pip

# install gcloud
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" |
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg |
    apt-key add -
# Update the package list and install the Cloud SDK
apt-get update && apt-get install -y google-cloud-sdk

# install docker-machine
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
