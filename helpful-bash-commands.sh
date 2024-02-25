#!/bin/bash

# Print verbose output for sctipt
set -x

# Make file executable
chmod u+x my-file.sh

# Configure ssh to use ssh keys for each host
~/.ssh/config

# To check what files would be modified(removed, updated, etc)
ls ~/.ssh/ed25519_test*