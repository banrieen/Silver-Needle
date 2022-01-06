#!/bin/bash
#=========================================================================================================================
# Info: 系统环境初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. Opensuse upgrade to particular release 
# 2. Config network, sshd and firewalld
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================
# 类似版本迭代更新
# Upgrade Release
releasever=15.4
# Recomend to use TMUX
sudo zypper ref
sudo zypper  up
sudo  hostnamectl
zypper repos --uri | grep -i update
cat /etc/zypp/repos.d/*.repo
sudo sed -i 's/15.1/${releasever}/g' /etc/zypp/repos.d/*.repo
sudo zypper --releasever=${releasever} refresh
sudo zypper --releasever=${releasever} dup  --force-resolution 
sudo reboot

sudo hostnamectl
sudo zypper ls -r

#-----------------------------------------------------------------------------------------------------------
#suse开发组的脚本
#!/bin/bash

echo 'Verify openSUSE Leap version 15.3'
cat /etc/os-release

echo 'Hardcode $releasever in Zypper repo files to 15.3'
sudo sed -i 's/15.3/${releasever}/g' /etc/zypp/repos.d/*.repo

echo 'Disable repos not yet available for openSUSE Leap 15.4 alpha. You should re-enable once 15.4 GA's.'
sudo sed -i 's/enabled=1/enabled=0/g' /etc/zypp/repos.d/repo-backports-update.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/zypp/repos.d/repo-sle-update.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/zypp/repos.d/repo-update.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/zypp/repos.d/repo-update-non-oss.repo
echo 'Refresh respositories'
sudo zypper --releasever=15.4 refresh
echo 'Run distribution upgrade'
sudo zypper --releasever=15.4 dup --download-in-advance -y
echo 'Verify openSUSE Leap version 15.4'
cat /etc/os-release