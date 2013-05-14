#!/bin/bash

HOSTNAME="`hostname -s`"
export RBACKUPDEST="s3+http://${HOSTNAME}.duplicitybackup"
backup.command
