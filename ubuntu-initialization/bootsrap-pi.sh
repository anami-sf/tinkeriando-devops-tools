#!/bin/bash

set -x

sed -re 's/^(PasswordAuthentication)([[:space:]]+)no/\1\2yes/' -i.`date -I` /etc/ssh/sshd_config

# Allow SSh connections =======================================================
# https://www.cyberciti.biz/faq/how-to-install-ssh-on-ubuntu-linux-using-apt-get/

#Update and upgrade packages
apt update -y
apt upgrade -y

# Install openssh
apt install openssh-client -y

# Enable ssh server on Ubuntu
systemctl enable ssh

# Install a firewall to close all incoming ports and explicitly allow incoming traffic to specific ports.
# By default, firewall will block ssh access. You must enable ufw and open ssh port 22 using ufw.

# Istall ufw: https://www.cyberciti.biz/faq/howto-configure-setup-firewall-with-ufw-on-ubuntu-linux/
apt install ufw 

# Open ssh port 22 
ufw allow 22/tcp

# !!! RELOAD system for settings to take efffect
service ssh reload

# How to start/stop/restart SSH server service on Ubuntu
<<comment
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl stop ssh
sudo systemctl restart ssh
comment

# How to connec to remote machine with ssh
<<comment
ssh user@server-ip
ssh admin@195.110.5.17
comment

# Settings that override the global settings for matching IP addresses only
<<comment
Match address 192.0.2.0/24
    PasswordAuthentication yes
comment
