#!/bin/bash

DEST_HOST="98.37.9.15"
REMOTE_USER="anami"
FILE="github-ssh.sh"

scp -P 22  $FILE ${remote}@${DEST_HOST}:~

echo "Run chmod u+x github-ssh.sh on remote to make this tile excutable"