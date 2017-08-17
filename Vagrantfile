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

  config.vm.define "ose-utils" do |d|
    d.vm.box = "rhel72-server-base.box"
    d.vm.hostname = "ose-utils.example.com"
    d.vm.network "private_network", ip: "10.100.192.201", auto_config: true
    d.vm.provider "virtualbox" do |v|
# minimum 3 Go, more if adding other containers such as CloudForms/ManageIQ admin console
      v.memory = 3072
#      v.memory = 6144
    end
    d.vm.provider :"virtualbox" do |vb|
      vb.gui = true
    end
  end

  (1..3).each do |i|
    config.vm.define "ose-node-#{i}" do |d|
      d.vm.box = "rhel72-server-base.box"
      d.vm.hostname = "ose-node-#{i}.example.com"
      d.vm.network "private_network", ip: "10.100.192.20#{i+1}", auto_config: true
      d.vm.provider "virtualbox" do |v|
# will depend on the application deployed on the nodes
        v.memory = 2048
#        v.memory = 3072
#        v.memory = 4086
#         v.memory = 5120
#        v.memory = 6144
#        v.memory = 8224
#        v.memory = 10240
         if i != 1
           v.memory = 1024
         end
        v.cpus = 2
# second disk for CNS
        disk = "gluster-storage-#{i}.vmdk"
        unless File.exist?(disk)
          v.customize ['createhd', '--filename', disk, '--size', 50 * 1024]
          v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        end
      end
      d.vm.provider :"virtualbox" do |vb|
        vb.gui = true
      end
    end
  end

  config.vm.define "ose-master" do |d|
      d.vm.box = "rhel72-server-base.box"
      d.vm.hostname = "ose-master.example.com"
      d.vm.network "private_network", ip: "10.100.192.200", auto_config: true
      d.vm.provider "virtualbox" do |v|
#        v.memory = 4096
#        v.memory = 3072
        v.memory = 2048
        v.cpus = 2
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
