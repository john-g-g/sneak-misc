#!/bin/bash

KEY_URL="https://sneak.cloud/authorized_keys"

curl -fLo /root/.ssh/authorized_keys --create-dirs $KEY_URL
curl -fLo /home/pi/.ssh/authorized_keys --create-dirs $KEY_URL
