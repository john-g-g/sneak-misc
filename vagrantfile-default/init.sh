#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
cd /vagrant && make inside
