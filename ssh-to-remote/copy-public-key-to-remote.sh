#!/bin/bash

set -x

username=$1
host=$2
private_key_file_path=$3
if [ -z ${private_key_file_path} ]; then private_key_file_path="$HOME/.ssh/ed25519_pi"; fi
public_key_file_path="$private_key_file_path.pub"
remove_password_remote_file="remove-password-authentication.sh"
remove_password_local_file="$HOME/code/devops/tinkeriando-devops-tools/ssh-to-remote/remove-password-authentication.sh"
sshd_config_file="$HOME/code/devops/tinkeriando-devops-tools/ssh-to-remote/remote-sshd_config"
port=22

ssh-copy-id -i "$public_key_file_path" -o StrictHostKeyChecking=no "$username@$host"

echo "========================================================================="
echo "Copy script to remove password athentication from remote host"
echo "Remote path: $remote_home_directory"
echo "========================================================================="

scp -P $port -i $private_key_file_path -o StrictHostKeyChecking=no $remove_password_local_file $username@$host:~

echo "========================================================================="
echo "ACTION: Run script to remove password authentication on remote host "
echo "ACTION: Run chmod u+x github-ssh.sh on remote to make this file excutable"
echo "Connecting to remote host: $username@$host ..." 
echo "========================================================================="

# sleep 20

scp -P $port -i $private_key_file_path -o StrictHostKeyChecking=no $sshd_config_file $username@$host:/etc/ssh/sshd_config
# ssh -i $private_key_file_path $username@$host "cat $sshd_config_file > /etc/ssh/sshd_config"  > $HOME/code/devops/tinkeriando-devops-tools/logs/remove-pass.txt
