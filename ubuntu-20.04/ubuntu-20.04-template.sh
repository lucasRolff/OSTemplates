#!/bin/bash

echo "
network:
    version: 2
    ethernets:
        eth0:
            match:
                name: e*
            addresses:
            - {{ ipv4_addr }}/32
            - {{ ipv6_addr }}
            routes:
            - to: 0.0.0.0/0
              via: 172.16.0.1
              on-link: true
            gateway6: 'fe80::1'
" > /etc/netplan/01-netcfg.yaml

resize2fs /dev/sda2

dpkg-reconfigure openssh-server

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

{% if sshkey %}
    mkdir -p /root/.ssh/
    echo "{{ sshkey }}" >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
{% endif %}