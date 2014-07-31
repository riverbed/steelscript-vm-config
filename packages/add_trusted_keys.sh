#!/bin/bash

# Each source package is digitally signed with a key from the
# Debian or Ubuntu developer community.  The script `add_keyrings.sh`
# can be used to install the suite of keys that are used for
# signings.

# This script will add those keys to the users trusted keyring.
# It should be run as the same user that will be downloading
# the source packages (using `download_source_packages.sh`).

echo "This script will import all system installed keyrings as "
echo "trusted.  This operation can take a long time (up to an hour) if all "
echo "system keyrings have been installed."

for KEY in `ls /usr/share/keyrings`; do
    echo "Processing $KEY..."
    gpg --keyring /usr/share/keyrings/$KEY --export|gpg --no-default-keyring --keyring ~/.gnupg/trustedkeys.gpg --import
done
