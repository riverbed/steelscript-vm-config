#!/bin/bash

# Run ansible commands from within the guest

sudo pip install ansible
sudo mkdir /etc/ansible &> /dev/null
echo localhost | sudo tee /etc/ansible/hosts &> /dev/null

sudo ansible-playbook -v -c local /vagrant/provisioning/provision.yml
