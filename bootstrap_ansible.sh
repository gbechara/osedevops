#!/bin/bash

set -e

echo "Installing Open Shift prereq ..., base vbox must contains adequate subs"
# yum update -y : better to update the box base box manually if needed for RHEL to avoid some issues
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.7-rpms" \
    --enable="rhel-7-fast-datapath-rpms"
yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct -y
yum update -y
yum install atomic-openshift-utils -y

echo "Launch ansible-playbook"

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''

for host in 10.100.192.200 \
10.100.192.201 \
10.100.192.202 \
10.100.192.203; \
#10.100.192.204; \
do sshpass -p "weareawesome" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $host; \
done

#sshpass -p "weareawesome"  ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub 10.100.192.200

# prepare the machines
echo "Prepare the machines"
ansible-playbook /vagrant/ansible/oseprerequesites.yml -i /vagrant/ansible/hosts

for host in ose-master.example.com \
ose-utils.example.com \
ose-node-1.example.com \
ose-node-2.example.com; \
#ose-node-3.example.com; \
do sshpass -p "weareawesome" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $host; \
done

# call ose installer
echo "Call OpenShift installer"
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml -i /vagrant/ansible/osehosts
# add users
echo "Add OpenShift users"
ansible-playbook /vagrant/ansible/oseusers.yml -i /vagrant/ansible/hosts
# finish set up
echo "Add nexus, gitlaba and examples"
ansible-playbook /vagrant/ansible/oseadditionalconf.yml -i /vagrant/ansible/hosts