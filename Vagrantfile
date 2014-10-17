# Copyright (c) 2014 Riverbed Technology, Inc.
#
# This software is licensed under the terms and conditions of the MIT License
# accompanying the software ("License").  This software is distributed "AS IS"
# as set forth in the License.


Vagrant.configure("2") do |config|

  config.vm.box = "SteelScriptVM"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.ssh.guest_port = 22

  config.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--memory", 512]
  end

  config.vm.provider :vmware_fusion do |v, override|
      override.vm.box = "SteelScriptVM-VMWare"
      override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
      v.vmx["numvcpus"] = "2"
      v.vmx["memsize"] = "512"
  end

  # setup ip to match ansible_hosts file
  config.vm.network :private_network, type: :dhcp
  config.vm.network :forwarded_port, guest:80, host: 30080
  config.vm.network :forwarded_port, guest:443, host: 30443
  config.vm.network :forwarded_port, guest:8000, host: 38000
  config.vm.network :forwarded_port, guest:8888, host: 38888

  # avoid root mesg issues from https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision :shell do |s|
      s.inline = "F=/vagrant/packages/installed_pkgs_pre_provision.txt && if [ ! -e $F ]; then  dpkg --get-selections > $F; fi"
  end

  config.vm.provision :ansible do |ansible|
      ansible.sudo = true
      ansible.playbook = "provisioning/provision.yml"
      ansible.verbose = true
  end

  config.vm.provision :shell do |s|
      s.inline = "F=/vagrant/packages/installed_pkgs_post_provision.txt && if [ ! -e $F ]; then dpkg --get-selections > $F; /home/vagrant/virtualenv/bin/pip freeze | grep -v ^-e > /vagrant/packages/installed_pkgs_python.txt; fi"
  end

end
