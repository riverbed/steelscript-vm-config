# Copyright (c) 2014 Riverbed Technology, Inc.
#
# This software is licensed under the terms and conditions of the MIT License
# accompanying the software ("License").  This software is distributed "AS IS"
# as set forth in the License.


Vagrant.configure("2") do |config|

  # this references the latest version in vagrant cloud
  config.vm.box = "puppetlabs/centos-6.5-64-nocm"
  #config.vm.box = "puppetlabs/centos-6.5-64-puppet"

  config.ssh.guest_port = 22

  config.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--memory", 512]
  end

  config.vm.provider :vmware_fusion do |v, override|
      v.vmx["numvcpus"] = "2"
      v.vmx["memsize"] = "512"
  end

  # setup ip to match ansible_hosts file
  #config.vm.network :private_network, type: :dhcp
  config.vm.network :forwarded_port, guest:80, host: 30080
  config.vm.network :forwarded_port, guest:8000, host: 38000
  config.vm.network :forwarded_port, guest:8888, host: 38888

  config.vm.provision :ansible do |ansible|
      ansible.sudo = true
      ansible.playbook = "provisioning/provision.yml"
      ansible.verbose = true
      #ansible.verbose = "vvvv"
  end

end
