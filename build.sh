#!/bin/bash

set -euxo pipefail

# This should be cleaned up

# This script loads the base OS and runs the installation process
# using kickstart

# "python -m SimpleHTTPServer" needs to be run at the same time
# in the same root folder to serve the kickstarts


# CENTOS 7
#location="http://mirror.karneval.cz/pub/centos/7/os/x86_64/"
#os=centos-7

# ubuntu 18.04
#location="http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/"
#os=ubuntu-18.04

# CENTOS 8
#location="http://mirror.karneval.cz/pub/centos/8/BaseOS/x86_64/os/"
#os=centos-8

# ubuntu 20.04
#location="/srv/ubuntu-20.04.3-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd"
#os=ubuntu-20.04

# oracle linux 8 unbreakable kernel
#cp /home/fhr/Downloads/OracleLinux8/OracleLinux-R8-U3-x86_64-dvd.iso /srv/
location="/srv/OracleLinux-R8-U3-x86_64-dvd.iso,initrd=isolinux/initrd.img,kernel=isolinux/vmlinuz"
os="oraclelinux-8"

echo "Destroying any stray running installs"
sudo virsh destroy ${os} || true; sudo virsh undefine ${os} || true

MY_IP="192.168.122.1"
BRIDGE="virbr0"

# Create disk
echo "Creating the volume"
rm "/srv/${os}.qcow2" || true
qemu-img create -q -f qcow2 -o cluster_size=64k,preallocation=metadata,compat=1.1,lazy_refcounts=on /srv/${os}.qcow2 5G

echo "Starting the installation process"
if [[ "${os}" == "ubuntu-20.04" ]]; then
	sudo virt-install \
		--name="${os}" \
		--memory=2048 \
		--vcpus=4 \
		--os-variant="rhel7.0" \
		--accelerate \
		-v \
		--os-type "linux" \
		--network bridge=${BRIDGE} \
		--console pty,target_type=serial \
		--disk /srv/${os}.qcow2 \
		--graphics=vnc \
		--location=${location} \
		--debug
		#--extra-args="console=ttyS0,115200n8 serial" \
		#--extra-args="autoinstall ds=nocloud-net;s=http://${MY_IP}:8000/${os}/" \

elif [[ "${os}" == "oraclelinux-8" ]]; then
	sudo virt-install \
		--name="${os}" \
		--memory=3072 \
		--vcpus=4 \
		--os-variant="rhel7.0" \
		--accelerate \
		-v \
		--os-type "linux" \
		--network bridge=${BRIDGE} \
		--console pty,target_type=serial \
		--disk /srv/${os}.qcow2 \
		--graphics=none \
		--extra-args="console=ttyS0,115200n8 serial" \
		--extra-args="ks=http://${MY_IP}:8000/${os}/ks.cfg" \
		--location=${location} \
		--debug

else
	sudo virt-install \
		--name="${os}" \
		--memory=3072 \
		--vcpus=4 \
		--os-variant="rhel7.0" \
		--accelerate \
		-v \
		--os-type "linux" \
		--network bridge=${BRIDGE} \
		--console pty,target_type=serial \
		--disk /srv/${os}.qcow2 \
		--extra-args="console=ttyS0,115200n8 serial" \
		--extra-args="ks=http://${MY_IP}:8000/${os}/ks.cfg" \
		--graphics=vnc \
		--location=${location} \
		--debug
fi

reset
#echo "Opening a console"
#sudo virsh console ${os}

echo "Destroying the VM"
sudo virsh destroy ${os}; sudo virsh undefine ${os}

echo "Compressing the template and deleting the disk image"
qemu-img convert -O qcow2 /srv/${os}.qcow2 /srv/${os}-template.qcow2 -c -o cluster_size=64k,compat=1.1,lazy_refcounts=on && rm /srv/${os}.qcow2

echo "Install complete"