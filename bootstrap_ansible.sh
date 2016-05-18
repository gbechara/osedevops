#!/bin/bash

set -e

echo "Installing Open Shift prereq ..., base vbox must contains adequate subs"
yum update -y
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.2-rpms"
yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion -y
yum update -y
yum install atomic-openshift-utils -y


#yum install docker-1.9.1 -y
#chkconfig NetworkManager off
#service NetworkManager stop

#nmcli connection modify enp0s3 +ipv4.dns 10.100.192.201
#nmcli connection modify  enp0s3 +ipv4.dns-search 'example.com'
#nmcli connection modify  enp0s3 ipv4.ignore-auto-dns true
#service NetworkManager restart


#mkdir -p /etc/ansible 
#touch /etc/ansible/hosts

#cp /etc/resolv.conf /etc/resolv.conf.upstream
#cp /vagrant/etc/dnsmasq.conf /etc/dnsmasq.conf
#systemctl enable dnsmasq; systemctl start dnsmasq
