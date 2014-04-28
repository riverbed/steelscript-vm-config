#!/bin/bash

# Run ansible commands from within the guest

sudo apt-get update
sudo apt-get -y install build-essential python-setuptools python-dev python-pip
sudo pip install ansible
sudo mkdir /etc/ansible &> /dev/null
echo localhost | sudo tee /etc/ansible/hosts &> /dev/null

sudo ansible-playbook -v -c local /vagrant/provisioning/provision.yml
