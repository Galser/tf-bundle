# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "galser/ubuntu-1804-vbox"
  config.vm.hostname = "tfcustom-bionic"
  config.vm.provision "file", source: "scripts", destination: "$HOME/scripts"
  config.vm.provision "file", source: "infra", destination: "$HOME/infra"
  config.vm.provision "shell", privileged: false, path: "scripts/bootstrap.sh"
 
end