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

workspace=$HOME
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# Get opensuse version id
# if [ -e /etc/os-release ]; then
# VERSION_ID=$(cat /etc/os-release | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# else
# VERSION_ID=$(cat /usr/lib/os-release  | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# fi

# Add user to particular group
USERNAME=$(whoami)
sudo usermod -a -G sudo $USERNAME
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
sudo sed -i 's/NETCONFIG_DNS_STATIC_SERVERS="/ETCONFIG_DNS_STATIC_SERVERS="114.114.114.114 8.8.8.8 192.168.1.1"/g' /etc/sysconfig/network/config
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
    && podman run -it --rm nvidia/cuda:11.0-base nvidia-smi

## Config nvidia-container rootless need cgroup-v2
## refer: [ootless Containers Setup](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#podman)
# sudo sed -i 's/^#no-cgroups = false/no-cgroups = true/;' /etc/nvidia-container-runtime/config.toml

# Install and setup podman 
sudo zypper in -y podman buildah skopeo && podman --version
## config rootless
# sudo usermod --add-subuids 200000-201000 --add-subgids 200000-201000 $USER
# sudo sed -i 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/g' /etc/default/grub
# sudo update-bootloader --refresh
# stat -c %T -f /sys/fs/cgroup
# sudo zypper install ./crun-0.21-4.1.x86_64.rpm
# reboot

## Update registries
sudo vim /etc/containers/registries.conf
[registries.search]
registries = ["nvcr.io", "docker.io"]
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
