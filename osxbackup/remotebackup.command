#!/bin/bash

HOSTNAME="`hostname -s`"
export RBACKUPDEST="s3+http://${HOSTNAME}.duplicitybackup"
source backup.command
