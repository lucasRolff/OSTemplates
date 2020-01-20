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

resize2fs /dev/sda2
