#!/bin/bash

set -x

# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Path to private ssh key
public_key_file_path=$HOME/.ssh/id_ed25519_github

# Generate key pair
ssh-keygen -t ed25519 -C "anami.127.0.0.1@gmail.com" -N "" -f $public_key_file_path 

# Start the ssh-agent in the background.
eval "$(ssh-agent -s)"

ssh-add $public_key_file_path

cat "$public_key_file_path.pub"

git config --global user.name "anami-sf"

git config --global user.email "anami.127.0.0.1@gmail.com"

vi ~/.ssh/config

<<comment
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519_github

git clone git@github.com:anami-sf/tinkeriando-devops-tools.git
comment

echo "Host github.com\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519_github" >> ~/.ssh/config
