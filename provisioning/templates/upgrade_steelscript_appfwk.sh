#!/bin/bash

shopt -s expand_aliases
source /home/vagrant/.vm_env.sh

function banner() {
   echo "***"
   echo $1
   echo "***"
}

# Run through the upgrade steps

banner "Uninstalling SteelScript ..."
steel uninstall --non-interactive

banner "Installing latest SteelScript package ..."
pip install steelscript

banner "Installing SteelScript App Framework and dependencies ..."
steel install --appfwk --steelhead

banner "Upgrading appfwk projects ..."
# update dev project
cdproject
python manage.py collectreports --overwrite
python manage.py reset_appfwk --force

# update server project
cdwww
sudo -u www-data `which python` manage.py collectreports --overwrite
sudo -u www-data `which python` manage.py collectstatic --noinput
sudo -u www-data `which python` manage.py reset_appfwk --force
sudo apachectl restart

banner "Done!"
echo "Current SteelScript config:"
steel about
