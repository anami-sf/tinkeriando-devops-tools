#!/bin/bash

read -p "Username: " username
read -p "Host name: " host
read -p "Generate new ssh key pair?(yes/no): " new_key_pair

if [[ "${new_key_pair}" == "yes" ]] ;then
  read -p "Name of key(ex. ed25519_pi): " key_name
  private_key_file_path="$HOME/.ssh/$key_name"  
  sudo sh ./generate-keys.sh $username $host $private_key_file_path
else
  sudo sh ./copy-public-key-to-remote.sh $username $host
fi
