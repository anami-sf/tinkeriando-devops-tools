#!/bin/bash

# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Path to private ssh key
sshKeyFilePath=~/.ssh/id_rsa_github

# Generate key pair
ssh-keygen -t ed25519 -C "anami.127.0.0.1@gmail.com" -N "" -f $sshKeyFilePath 

# Start the ssh-agent in the background.
eval "$(ssh-agent -s)"

ssh-add $sshKeyFilePath

cat ${sshKeyFilePath}.pub
