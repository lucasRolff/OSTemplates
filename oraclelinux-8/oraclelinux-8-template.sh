#!/bin/bash

echo "
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
IPV6INIT=yes
IPV6_FAILURE_FATAL=no
IPV6ADDR={{ ipv6_addr }}
IPV6_DEFAULTGW=fe80::1%eth0
" > /etc/sysconfig/network-scripts/ifcfg-eth0

{% if sshkey %}
    mkdir -p /root/.ssh/
    echo "{{ sshkey }}" >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
{% endif %}

resize2fs /dev/sda1
