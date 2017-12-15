# Copyright (c) 2014 Riverbed Technology, Inc.
#
# This software is licensed under the terms and conditions of the MIT License
# accompanying the software ("License").  This software is distributed "AS IS"
# as set forth in the License.

# Configure 'sources' symlink, will abort if link already exists
system("
    if [ #{ARGV[0]} == 'up' ] || [ #{ARGV[0]} == 'provision' ]; then
        if [ $(grep -c '[^#]deployment_type.*distribution' provisioning/provision.yml) -ne 0 ]; then
            cd dev
            ./link-steelscript.py
        fi
    fi
")

Vagrant.configure("2") do |config|

  # this references the latest version in vagrant cloud
  config.vm.box = "steelscript-base-os"
  config.vm.box_url = ["http://cook.lab.nbttech.com/downloads/vagrant/steelscript-base-os.json"]
  config.vm.define :steelscript_vm_1_2 do |t|
  end

  config.ssh.guest_port = 22

  # port forwarding
  config.vm.network :forwarded_port, guest:80, host: 30080
  config.vm.network :forwarded_port, guest:443, host: 30443
  config.vm.network :forwarded_port, guest:8000, host: 38000
  config.vm.network :forwarded_port, guest:8888, host: 38888

  config.vm.provider :virtualbox do |v, override|
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provider :vmware_fusion do |v, override|
      v.vmx["numvcpus"] = "2"
      v.vmx["memsize"] = "2048"
  end

  # shared folder to synced sources directory
  # link created by link-steelscript.py script
  config.vm.synced_folder "sources/", "/src"

  # avoid root mesg issues from https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision "pre-provision", type: "shell" do |s|
      s.inline = "F=/vagrant/packages/installed_pkgs_pre_provision.txt && if [ ! -e $F ]; then yum list installed > $F; fi"
  end

  config.vm.provision "ansible" do |ansible|
      ansible.become = true
      ansible.playbook = "provisioning/provision.yml"
      ansible.verbose = true
      #ansible.verbose = "vvvv"
  end

  config.vm.provision "post-provision", type: "shell" do |s|
      s.inline = "F=/vagrant/packages/installed_pkgs_post_provision.txt && if [ ! -e $F ]; then yum list installed > $F; /home/vagrant/virtualenv/bin/pip freeze | grep -v ^-e > /vagrant/packages/installed_pkgs_python.txt; fi"
  end

end
