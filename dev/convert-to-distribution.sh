#!/bin/bash


# This script converts a vm from a development mode to a distribution mode

# With distribution mode, all the python packages are installed
# directly to the virtualenv, and dev mode has them installed 
# editable mode, or via "pip install -e"

source /home/vagrant/.vm_env.sh


# remove existing
steel uninstall --non-interactive

# reinstall
pip install steelscript
steel install --appfwk --steelhead

# update project links to new location
cd /steelscript/www
sudo rm manage.py
sudo -u apache ln -s /home/vagrant/virtualenv/lib/python2.7/site-packages/steelscript/appfwk/apps/../manage.py
sudo rm media
sudo -u apache ln -s /home/vagrant/virtualenv/lib/python2.7/site-packages/steelscript/appfwk/apps/../media
sudo rm thirdparty
sudo -u apache ln -s /home/vagrant/virtualenv/lib/python2.7/site-packages/steelscript/appfwk/apps/../thirdparty

# update progressd service to new location
sed -i.bak -e 's#/src/steelscript-appfwk/steelscript/appfwk/progressd#/home/vagrant/virtualenv/lib/python2.7/site-packages/steelscript/appfwk/progressd#' /etc/init.d/progressd
sudo service progressd restart

# reset appfwk
cd /steelscript/www
sudo -u apache /home/vagrant/virtualenv/bin/python manage.py collectreports --overwrite
sudo -u apache /home/vagrant/virtualenv/bin/python manage.py reset_appfwk --force --drop-users
sudo -u apache /home/vagrant/virtualenv/bin/python manage.py collectstatic --noinput

# restart services
appfwk_restart_services
