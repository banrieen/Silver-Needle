!/bin/bash
#=========================================================================================================================
# Info: 系统环境初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. Online install tools
# 2. Offline installation
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# Bash execute process status bar
## https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
## https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
## https://ownyourbits.com/2017/07/16/a-progress-bar-for-the-shell/

# Online installation
#-------------------------------------------------------------------------------------------------------------------------
workspace=$HOME
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install -y code

# Install OBS
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper dup --from packman --allow-vendor-chang
sudo zypper in obs-studio

# Install frps 
wget https://github.com/fatedier/frp/releases/download/v0.42.0/frp_0.42.0_linux_amd64.tar.gz
tar zxf frp_0.42.0_linux_amd64.tar.gz
cp frps /usr/local/bin/frps
sudo mkdir /etc/frp
cp frps.ini /etc/frp/frps.ini

## Server configuration
sudo chmod 775 -R /etc/frp/
cat > /etc/frp/frps.ini << EOF
[common]
bind_port = 7000
dashboard_port = 7500
token = Aiops@2025
dashboard_user = admin
dashboard_pwd = Aiops@2025
vhost_http_port = 10080
vhost_https_port = 10443
allow_ports = 20000-40000,6022,7022,7080,30692,30184,32109,8088,8090,8080,9090,9091
EOF
sudo chmod 555 -R /etc/frp/

## Server systemctl setup
sudo cat > /etc/systemd/system/frps.service << EOF
[Unit]
Description=frps
Wants=network-online.target
After=network.target

[Service]
type=simple
#TimeoutStartSec=30
#RemainAfterExit=yes
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
ExecStop=/bin/kill -2 $MAINPID
Restart=on-failure
RestartSec=30s
KillMode=none

[Install]
WantedBy=multi-user.target

EOF

## 启动 frps 并设置开机启动
sudo systemctl stop frps
sudo systemctl disable frps
sudo systemctl start frps
sudo systemctl enable frps
### sudo systemctl status frps

## client configuration
sudo chmod 775 -R /etc/frp/
cat > /etc/frp/frpc.ini << EOF
[common]
server_addr =  122.51.195.199
server_port = 7000
token = Aiops@2025
[ssh]
type = tcp
local_ip = 127.0.0.1 
local_port = 2025
remote_port = 6022
[smb]
type = tcp
local_ip = 127.0.0.1
local_port = 445
remote_port = 7002
EOF
sudo chmod 555 -R /etc/frp/

## client systemctl setup
 cat > /etc/systemd/system/frpc.service << EOF
  [Unit]
  Description=frpc
  Wants=network-online.target
  After=network.target

  [Service]
  type=simple
  #RemainAfterExit=yes
  TimeoutStartSec=120
  ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
  ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini
  ExecStop=/bin/kill -2 $MAINPID
  Restart=on-failure
  RestartSec=30s
  KillMode=none

  [Install]
  WantedBy=multi-user.target
~
EOF

## 启动 frpc 并设置开机启动
sudo systemctl stop frpc
sudo systemctl disable frpc
sudo systemctl start frpc
sudo systemctl enable frpc

## Start with screen in WLS 
sudo screen -dmS frpc /usr/local/bin/frpc -c /etc/frp/frpc.ini &

# Discoursepython
### https://github.com/discourse/discourse.git
curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
docker-compose up -d

## python env

sudo zypper install -y "python>=3.7"
sudo rm /usr/bin/python3
sudo ln -s /usr/bin/python3.9 /usr/bin/python3
curl -O https://bootstrap.pypa.io/get-pip.py
python3 ./get-pip.py


# Offline installation (Debin/Ubuntu)
#-------------------------------------------------------------------------------------------------------------------------
## Refer: https://ostechnix.com/download-packages-dependencies-locally-ubuntu/
mkdir $HOME/offline && cd $H--download-onlyOME/offline
sudo apt-get install --download-only openssh-server
for i in $(apt-cache depends python | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/); do sudo apt-get download $i 2>>errors.txt; done 
zip -o offline.zip ./*

sudo dpkg -i *
### Another Motheds
# aptitude clean
# aptitude --download-only install <your_package_here>
# cp /var/cache/apt/archives/*.deb <your_directory_here>

# Linux 系统管理工具
sudo zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay:cockpit/openSUSE_Tumbleweed/home:Dead_Mozay:cockpit.repo
sudo zypper refresh
sudo zypper install cockpit

# pytorch 环境
## Use podman volume: data2vec
sudo podman run -it -d --rm -v data2vec:/data nvcr.io/nvidia/pytorch:21.11-py3 bash
