#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

PKGS="
    apt-utils
    bind9-host
    bonnie++
    build-essential
    byobu
    command-not-found
    daemontools
    debmirror
    docker
    fortune
    git
    irssi
    jq
    ldap-auth-client
    ldap-utils
    lsof
    libxml2
    libxml2-dev
    mailutils
    make
    mosh
    mutt
    nmap
    nodejs
    npm
    nscd
    pbzip2
    pv
    pwgen
    python
    python-dev
    python-pip
    rbenv
    rsync
    rsyslog
    rsyslog-gnutls
    rsyslog-relp
    runit
    screen
    snmp
    snmp-mibs-downloader
    snmpd
    telnet
    texlive-latex-base
    tmux
    vagrant
    vim
    wamerican-insane
    wget
"

apt-get update
apt-get -y upgrade
apt-get install -y $PKGS

# use faster one:
OLD="$(which bzip2)"
rm $OLD
ln $(which pbzip2) $OLD

git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build

cd /usr/local/bin
wget https://raw.githubusercontent.com/sneak/ppss/master/ppss
chmod +x ./ppss

NPM_PKGS="
    coffee-script
    coffeelint
"

# update npm
npm update -g --loglevel info npm
for PKG in $NPM_PKGS ; do
    npm install -g --loglevel info $PKG
done

PIP_PKGS="
    virtualenv
    pylint
    awscli
"

pip install --upgrade pip
pip install setuptools
pip install pip-review
pip-review --verbose --auto
for PKG in $PIP_PKGS; do
    pip install $PKG
done

# cleanup

rm -rf \
    /root/.cache \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /core
