#!/bin/bash

echo "
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet static
    address {{ ipv4_addr }}
    netmask 255.255.255.255
    gateway 172.16.0.1
    pointopoint 172.16.0.1
    dns-nameservers 8.8.8.8 1.1.1.1
    
iface eth0 inet6 static
    address {{ ipv6_addr }}
    netmask 64
    gateway fe80::1
" > /etc/network/interfaces

echo "
nameserver 8.8.8.8
nameserver 1.1.1.1
" > /etc/resolv.conf

resize2fs /dev/sda1

ssh-keygen -A

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

{% if sshkey %}
    mkdir -p /root/.ssh/
    echo "{{ sshkey }}" >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
{% endif %}
