# Copyright (c) 2013 Riverbed Technology, Inc.
# This software is licensed under the terms and conditions of the MIT License set
# forth at https://github.com/riverbed/flyscript-vm-config/blob/master/LICENSE
# ("License").  This software is distributed "AS IS" as set forth in the License.


Vagrant::Config.run do |config|
  
  config.vm.box = "FlyScriptVM"
  config.ssh.guest_port = 22
  config.vm.customize ["modifyvm", :id, "--memory", 512]
  config.vm.forward_port 80, 30080
  config.vm.forward_port 8888, 38888

   config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file  = "init.pp"
     puppet.module_path = "modules"
     puppet.options = "--verbose --debug"
     # Uncomment the following line and update proxy values if behind a proxy
     #puppet.options = "--verbose --debug --http_proxy_host=<proxy_host> --http_proxy_port=<proxy_port>"
   end
   
end
