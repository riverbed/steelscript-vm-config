
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
     #puppet.options = "--verbose"
   end
   
end
