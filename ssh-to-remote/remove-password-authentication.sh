#!/bin/bash

# This file needs to be run as sudo

set -x

echo "========================================================================="
echo "Remove password authentication from remote"
echo "========================================================================="

TEMP_SED=$(sed -re 's/^(PasswordAuthentication)([[:space:]]+)yes/\1\2no/' -i.`date -I` /etc/ssh/sshd_config)
echo "$TEMP_SED" > /etc/ssh/sshd_config
unset TEMP_SED
