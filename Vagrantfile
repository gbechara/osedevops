# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

#  config.registration.username = 'user-name'
#  config.registration.password = 'password'
#  config.registration.pools = [ 'poolid' ]
  config.vm.synced_folder "ansible", "/vagrant/ansible"

#  config.vm.synced_folder "ansible", "/vagrant/ansible", owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=755', 'fmode=664', 'context=system_u:object_r:vmblock_t:s0']

#  config.vm.synced_folder "ansible", "/vagrant/ansible", owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=755', 'fmode=664', 'context=system_u:object_r:virt_use_nfs:s0']

  
  config.vm.define "ose-infra" do |d|
    d.vm.box = "rhel72-server-base.box"
    d.vm.hostname = "ose-infra.example.com"
    d.vm.network "private_network", ip: "10.100.192.201"
    d.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
    d.vm.provider :"virtualbox" do |vb|
      vb.gui = true
    end
  end

  (1..1).each do |i|
    config.vm.define "ose-node-#{i}" do |d|
      d.vm.box = "rhel72-server-base.box"
      d.vm.hostname = "ose-node-#{i}.example.com"
      d.vm.network "private_network", ip: "10.100.192.20#{i+1}"
      d.vm.provider "virtualbox" do |v|
        v.memory = 2048
      end
      d.vm.provider :"virtualbox" do |vb|
        vb.gui = true
      end
    end
  end

  config.vm.define "ose-master" do |d|
      d.vm.box = "rhel72-server-base.box"
      d.vm.hostname = "ose-master.example.com"
      d.vm.network "private_network", ip: "10.100.192.200"
      d.vm.provider "virtualbox" do |v|
#        v.memory = 4096
        v.memory = 3072
      end
      d.vm.provision :"shell", path: "bootstrap_ansible.sh"
#      d.vm.provider "virtualbox" do |v|
#        v.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
#      end
      d.vm.provider :"virtualbox" do |vb|
        vb.gui = true
      end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end


end
