#!/bin/bash

set -x

# These commands need to be run as sudo, so run the file with sudo or add sudo to individual commands

group="settings-admin"

# Create user group
groupadd $group 

# Add current user to group
usermod -a -G $group $SUDO_USER

# Give the admin group ownership of the /etc directory
chgrp -R $group /etc

# Give the admin group rwx permissions to the /etc directory
chmod -R g+rw /etc
