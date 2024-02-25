#!/bin/bash

set -x

username=$1
host=$2
private_key_file_path=$3

ssh-keygen -t ed25519 -N "" -f $private_key_file_path

chmod 700 $HOME/.ssh
chmod 600 $private_key_file_path.pub
chmod 600 $private_key_file_path

sudo sh ./copy-public-key-to-remote.sh $username $host $private_key_file_path
