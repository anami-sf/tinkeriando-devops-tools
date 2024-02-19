#!/bin/bash

set -x

# Configfile
. copy-files-to-remote/node.config

# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Path to private ssh key
public_key_file_path=~/.ssh/id_ed25519_github

# Generate key pair
ssh-keygen -t ed25519 -C "anami.127.0.0.1@gmail.com" -N "" -f $public_key_file_path 

# Start the ssh-agent in the background.
eval "$(ssh-agent -s)"

ssh-add $public_key_file_path

cat ${public_key_file_path}.pub
