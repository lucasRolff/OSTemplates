#!/bin/bash

echo "
network:
    version: 2
    ethernets:
        eth0:
            match:
                name: e*
            dhcp4: true
            addresses:
            - {{ ipv6_addr }}
            gateway6: 'fe80::1'
" > /etc/netplan/01-netcfg.yaml

resize2fs /dev/sda2

dpkg-reconfigure openssh-server

{% if sshkey %}
    mkdir -p /root/.ssh/
    echo "{{ sshkey }}" >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
{% endif %}