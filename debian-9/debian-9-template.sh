#!/bin/bash

echo "
auto lo
iface lo inet loopback

allow-hotplug ens3
iface ens3 inet dhcp
iface ens3 inet6 static
    address {{ ipv6_addr }}
    netmask 64
    gateway fe80::1
" > /etc/network/interfaces

resize2fs /dev/sda2

ssh-keygen -A

echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
