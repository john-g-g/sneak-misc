#!/bin/bash

set -x

export TRANSPORTURL="https://raw.githubusercontent.com/JaquerEspeis/apt-transport-ipfs/master/ipfs"

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y golang runit runit-systemd git lsb-release python3-pip
pip3 install ipfsapi

go get -u github.com/ipfs/ipfs-update && \
/root/go/bin/ipfs-update install latest && \
adduser --system --group --home /var/lib/ipfs ipfs && \
mkdir /etc/service/ipfsd && \
curl -f $TRANSPORTURL > /usr/lib/apt/methods/ipfs && \
chmod +x /usr/lib/apt/methods/ipfs

cat > /etc/service/ipfsd/run <<'__EOF__'
#!/bin/bash

sleep 1 # prevent cpu spike on looping

export HOME="/var/lib/ipfs"
export IPFS="/usr/local/bin/ipfs"
cd $HOME

export IPFS_PATH="$HOME"

if [[ ! -e "$IPFS_PATH/config" ]]; then
    chpst -u ipfs $IPFS init
fi

exec chpst -u ipfs $IPFS daemon
__EOF__
chmod +x /etc/service/ipfsd/run

NS="Qme4tKNduvAgQKN6nKjyH7KjyMdJwyPHfeVMp2EUS6b3J1"
MUMR="main universe multiverse restricted"
cat > /etc/apt/sources.list.new <<__EOF__
deb ipfs:/ipns/$NS $(lsb_release -cs)           $MUMR
deb ipfs:/ipns/$NS $(lsb_release -cs)-updates   $MUMR
deb ipfs:/ipns/$NS $(lsb_release -cs)-security  $MUMR
deb ipfs:/ipns/$NS $(lsb_release -cs)-backports $MUMR
__EOF__

if [[ ! -e /etc/apt/sources.list.orig ]]; then
    mv /etc/apt/sources.list /etc/apt/sources.list.orig
fi
mv /etc/apt/sources.list.new /etc/apt/sources.list
sleep 5

if [[ ! -d $HOME/.ipfs ]]; then
    mkdir -p $HOME/.ipfs
    echo -n '/ip4/127.0.0.1/tcp/5001' > $HOME/.ipfs/api
fi

dpkg --remove-architecture i386
rm -rf /var/lib/apt/lists/*
apt update

