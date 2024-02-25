#!/bin/bash

set -x

. ssh-to-remote/node.config

read -p "Enter path to local file: " path_to_local_file

scp -P $port $path_to_local_file "$username@$host":$remote_home_directory

echo "Run chmod u+x github-ssh.sh on remote to make this tile excutable"