#!/bin/bash

set -e

echo "Launch ansible-playbook"

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' 
echo password > password.txt
for host in 10.100.192.200 \
    10.100.192.201 \
    10.100.192.202; \
    do sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $host; \
    done

#sshpass -p "password"  ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub 10.100.192.200

ansible-playbook /vagrant/ansible/network.yml -i /vagrant/ansible/allhosts

for host in ose-master.example.com \
    ose-infra.example.com \
    ose-node-1.example.com; \
    do sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $host; \
    done

ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml -i /vagrant/ansible/osehosts
ansible-playbook /vagrant/ansible/oseusers.yml -i /vagrant/ansible/oseusershost