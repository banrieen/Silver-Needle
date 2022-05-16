#!/bin/bash
#=========================================================================================================================
# Info: 系统环境初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. OS System update, hypervisor, account, 
# 2. Config network, sshd and firewalld
# 3. Install and config gpu driver and cuda toolkits 
# 4. Install podman and enable rootless, Nvidia-container-toolkit
# 5. Install another usefull tools
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================


## Opensuse 15.3
workspace=$HOME
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# Get opensuse version id
# if [ -e /etc/os-release ]; then
# VERSION_ID=$(cat /etc/os-release | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# else
# VERSION_ID=$(cat /usr/lib/os-release  | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# fi

## Install common tools with root, iwhile sudo is not found. 
su root 
zypper update && zypper install -y sudo vim usbutils
# Add user to particular group
USERNAME=$(whoami)
# sudo usermod -a -G sudo $USERNAME
sudo usermod -a -G root $USERNAME
sudo usermod -a -G docker $USERNAME
# Add to sudoers without passwd
sudo echo 'yijie  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers
sudo echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# config network, enabel wicked
## Refer: https://doc.opensuse.org/documentation/leap/reference/html/book-reference/cha-network.html
sudo systemctl is-active network && \
sudo systemctl stop      network
sudo systemctl enable --force wicked
sudo systemctl start wickedd
sudo systemctl start wicked
## Default config dhcp
'''
yijie@localhost:~> sudo cat /etc/sysconfig/network/ifcfg-eth0 
NAME=''
BOOTPROTO='dhcp'
STARTMODE='auto'
ZONE=''
'''
## Config static ip and route 
### Be sure the network mask is keep up with localnetwork
sudo su
sudo chmod +w /etc/sysconfig/network/ifcfg-eth0
sudo echo """
BOOTPROTO='static'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='192.168.3.73/22'
MTU='9000'
NAME=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='onboot'
ZONE=''
""" > /etc/sysconfig/network/ifcfg-eth0
sudo chmod -w /etc/sysconfig/network/ifcfg-eth0
sudo chmod +w /etc/sysconfig/network/ifroute-eth0
sudo echo "default 192.168.1.1 - eth0" >  /etc/sysconfig/network/ifroute-eth0
sudo chmod -w /etc/sysconfig/network/ifroute-eth0
exit
## Add dns search list
sudo sed -i 's/NETCONFIG_DNS_STATIC_SERVERS=""/NETCONFIG_DNS_STATIC_SERVERS="114.114.114.114 8.8.8.8 192.168.1.1"/g' /etc/sysconfig/network/config
## Restart network
sudo systemctl restart wickedd.service
sudo wicked ifup eth0
### sudo systemctl status wickedd.service

# Install GPU Driver & cuda toolkit
zypper addrepo --refresh 'https://download.nvidia.com/opensuse/leap/$distribution' NVIDIA
sudo hwinfo --gfxcard | grep Model
sudo hwinfo --arch
sudo zypper se -s x11-video-nvidiaG0*
sudo zypper se nvidia-glG0*
sudo zypper in -y x11-video-nvidiaG05 nvidia-glG05

wget https://developer.download.nvidia.com/compute/cuda/11.4.1/local_installers/cuda_11.4.1_470.57.02_linux.run
sudo sh cuda_11.4.1_470.57.02_linux.run

sudo echo """
export PATH=/home/thomas/bin:/usr/local/bin:/usr/bin:/bin:/home/thomas/minio-binaries/:/home/thomas/minio-binaries/:/usr/local/cuda-11.4/bin
export LD_LIBRARY_PATH=:/usr/local/cuda-11.4/lib64
""" >> ~/.bashrc
source ~/.bashrc

# Install nvidia-container-toolkit
sudo zypper ar https://download.opensuse.org/repositories/Virtualization:/containers/${distribution}/Virtualization:containers.repo   \
    && sudo zypper ref  \
    && sudo zypper install -y nvidia-container-toolkit \
    && sudo podman run -it --rm nvidia/cuda:11.0-base nvidia-smi

## Config nvidia-container rootless need cgroup-v2
## refer: [ootless Containers Setup](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#podman)
# sudo sed -i 's/^#no-cgroups = false/no-cgroups = true/;' /etc/nvidia-container-runtime/config.toml

# Install and setup podman 
sudo zypper in -y podman buildah skopeo && podman --version
## config rootless
sudo usermod --add-subuids 200000-201000 --add-subgids 200000-201000 $USER
# sudo sed -i 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/g' /etc/default/grub
# sudo update-bootloader --refresh
# stat -c %T -f /sys/fs/cgroup
# sudo zypper install ./crun-0.21-4.1.x86_64.rpm
# reboot

## Update registries
sudo sed -i 's/registry.opensuse.org/nvcr.io/' /etc/containers/registries.conf
## if a container starts a particular application, the container exits as soon as the application quits. 
## podman start -ai <container name>
## loginctl list-sessions | grep $USER

# Update sshd port
sudo systemctl enable sshd && sudo systemctl start sshd
sudo sed -i 's/^#Port 22/Port 2025/;' /etc/ssh/sshd_config 
sudo systemctl restart sshd.service
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=2025/tcp --permanent
sudo firewall-cmd --zone=public --remove-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload 
sudo firewall-cmd --list-ports
sudo firewall-cmd --list-services --permanent 
## reboot
## loginctl kill-session SESSION_ID
# =============================================================================================================================


## Ubuntu 18.04


## Install podman
export http_proxy="http://192.168.3.115:7890"
export https_proxy="http://192.168.3.115:7890"

export http_proxy="http://192.168.31.246:7890"
export https_proxy="http://192.168.31.246:7890"
sudo apt-get update

. /etc/os-release
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/testing/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:testing.list
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/testing/xUbuntu_20.04/Release.key" | sudo apt-key add -
sudo apt-get update -qq
sudo apt-get -qq -y install podman

## Windows11 wsl2
wsl --install

Step 1: Enable Windows Subsystem for Linux (WSL)

Open the Windows Terminal or Powershell, and type the following command to enable WSL:

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Step 2: Enable Windows Virtual Machine Platform

In the Windows Terminal or Powershell, type the following command to enable Windows Virtual Machine Platform:

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Step 3: Update the Linux kernel to the latest version

This requires you to download the WSL2 Linux kernel update MSI package, choose the appropriate version from below, and install it. 1. WSL2 Linux kernel update MSI package for x64 systems 2. WSL2 Linux kernel update MSI package for ARM64 systems
Step 4: Set WSL2 as the default version

Installing WSL2 in Step #3 doesn't change the default version of WSL from 1 to 2. To change the default version of WSL, you must run the following command in terminal or powershell:

wsl --set-default-version 2


