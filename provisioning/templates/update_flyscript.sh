#!/bin/bash

# Run this script to update the installed flyscript portal to 
# the latest git version

# must be run as root, or via sudo

cd /flyscript/flyscript_portal
git pull
./clean --deploy
#./clean --reset
chown -R apache:apache *
apachectl restart


