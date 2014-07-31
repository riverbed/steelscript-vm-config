#!/bin/bash

# Each source package is digitally signed with a key from the Debian or Ubuntu
# developer community.  This script will install the suite of keyrings that
# should include all the keys used for signing.

# Note there may be keyrings here which are unnecessary for only installing the
# source packages, there hasn't been much experimentation to determine the
# bare-minimum necessary.

# This needs to be run as root.

# Once complete, run `add_trusted_keys.sh` as the user you will install
# the source packages under (can be the normal user account)

sudo apt-get install ubuntu-keyring
#sudo apt-get install ubuntu-extras-keyring
#sudo apt-get install debian-keyring
sudo apt-get install debian-archive-keyring
#sudo apt-get install debian-ports-archive-keyring

