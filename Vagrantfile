# Copyright (c) 2013 Riverbed Technology, Inc.
# This software is licensed under the terms and conditions of the MIT License set
# forth at https://github.com/riverbed/flyscript-vm-config/blob/master/LICENSE
# ("License").  This software is distributed "AS IS" as set forth in the License.


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
      override.vm.box_url = "http://files.vagrantup.com/precise64_fusion.box"
      v.vmx["numvcpus"] = "2"
      v.vmx["memsize"] = "512"
  end

  # setup ip to match ansible_hosts file
  config.vm.network :private_network, type: :dhcp
  config.vm.network :forwarded_port, guest:80, host: 30080
  config.vm.network :forwarded_port, guest:8000, host: 38000
  config.vm.network :forwarded_port, guest:8888, host: 38888

  config.vm.provision :ansible do |ansible|
      ansible.sudo = true
      ansible.playbook = "provisioning/provision.yml"
      ansible.verbose = true
  end

end
