#!/bin/bash

set -x

cd / && sudo mkdir --parents code/devops-tools
sed -re 's/^(PasswordAuthentication)([[:space:]]+)no/\1\2yes/' -i.`date -I` /etc/ssh/sshd_config

# Allow SSh connections =======================================================
# https://www.cyberciti.biz/faq/how-to-install-ssh-on-ubuntu-linux-using-apt-get/

#Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

# Install openssh
sudo apt install openssh-client -y

# Enable ssh server on Ubuntu
sudo systemctl enable ssh

# Install a firewall to close all incoming ports and explicitly allow incoming traffic to specific ports.
# By default, firewall will block ssh access. You must enable ufw and open ssh port 22 using ufw.

# Istall ufw: https://www.cyberciti.biz/faq/howto-configure-setup-firewall-with-ufw-on-ubuntu-linux/
sudo apt install ufw 

# Open ssh port 22 
sudo ufw allow 22/tcp

# !!! RELOAD system for settings to take efffect
service ssh reload

# How to start/stop/restart SSH server service on Ubuntu
'''
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl stop ssh
sudo systemctl restart ssh
'''

# How to connec to remote machine with ssh
'''
ssh user@server-ip
ssh admin@195.110.5.17
'''

# Settings that override the global settings for matching IP addresses only
'''
Match address 192.0.2.0/24
    PasswordAuthentication yes
'''
