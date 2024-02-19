#!/bin/bash

set -x

# Configfile
. copy-files-to-remote/node.config

ssh-keygen -t ed25519 -N "" -f $public_key_file_path

ssh-copy-id -i $public_key_file_path "$username@$host"

#Remove athentication with password
# Updte file /etc/ssh/sshd_config
sed -re 's/^(PasswordAuthentication)([[:space:]]+)yes/\1\2no/' -i.`date -I` /etc/ssh/sshd_config