
WORK IN PROGRESS

## Base VirtualBox VM

```sh
$> subscription-manager register --username <user> --password <password>

```

```sh
$> subscription-manager repos --disable="*"
$> subscription-manager repos --enable="rhel-7-server-rpms"
$> yum update -y
```

### VirtualBox Guest additions

VirtualBox Guest additions should be installed on the VM in order a propre use of Vagrant. Pre-requisites utilities should be installed first:

```sh
$> yum install bzip2
$> yum install gcc
$> yum install kernel-devel
```

Then, Guest additions can be mounted and installed into guest VM. Into VirtualBox menu, go to `Devices`and then `Install Guest Additions CD image...`. ISO is now made available into VM, we have to mount it to cdrom location before executing install:

```sh
$> mkdir /media/cdrom
$> mount /dev/cdrom /media/cdrom
$> cd /media/cdrom
$> ./VBoxLinuxAdditions.run
```

### Vagrant additions

First, create a `vagrant` user with default `vagrant` password in your base VM as explained here `https://www.vagrantup.com/docs/boxes/base.html`:

```sh
$> useradd vagrant
$> passwd vagrant
```

Then, check and enforce SSH activation on VM boot:

```sh
$> chkconfig sshd on
```

We should now retrieve the SSH default insecure keys provided by Vagrant in order to be later able to connect to the box. This consists in following commands:

```sh
$> mkdir -m 0700 -p /home/vagrant/.ssh
$> curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
$> chmod 0600 /home/vagrant/.ssh/authorized_keys
$> chown -R vagrant:vagrant /home/vagrant/.ssh
```

`vagrant` user should also be able to sudo without passwords, so we have to add:

```sh
$> sed -i 's/^\(Defaults.*requiretty\)/#\1/' /etc/sudoers
$> echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

```
Finally, we do some cleanup before packaging the VM as Vagrant box:

```sh
$> yum clean all
$> rm -rf /tmp/*
$> rm -f /var/log/wtmp /var/log/btmp
$> history -c
```

## Base Vagrant box

From your host machine, launch the packaging of VirtualBox VM into a base Vagrant box :

```sh
$> vagrant package --base rhel72-server-base
```

This command outputs a `package.box` file within current directory and you now have to register it within Vagrant as a base box:

```sh
$> vagrant box add rhel72-server-base.box package.box
```
If you made iterations on this differents steps, Vagrant registration should be forced otherwise new version of VM will not ovverides previous ones. Just add the `--force` flag like this:

```sh
$> vagrant box add --force rhel72-server-base.box package.box
```
