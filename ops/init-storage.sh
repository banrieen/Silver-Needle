# !/bin/bash
#=========================================================================================================================
# Info: 存储初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. Setup hardare, disk, cluster net
# 2. Deploy minIO as services
# 3. maintainer 
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# Mount disk
# manual setup
lsblk
## 按照btrfs格式化分区
# fdisk /dev/sdc -n 1 2
# sudo mkfs  -t btrfs -f /dev/sdc1
mkdir -p /data/diska
DiskUUID=$(sudo blkid /dev/sda1 | cut -d' ' -f2)
sudo chmod +x /etc/fstab
sudo echo "${DiskUUID}  /data/diska             btrfs  defaults     0    0" >> /etc/fstab
sudo chmod -x /etc/fstab

# Deploy minIO services
## echo "12|23|11" | awk '{split($0,a,"|"); print a[3],a[2],a[1]}'

# Setup firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=9000/tcp --permanent
sudo firewall-cmd --reload

export MINIO_ROOT_USER=yijie
export MINIO_ROOT_PASSWORD=yijie@2025
export mount_stand=/data/diska
mkdir -p ${HOME}/.minio/certs
## Generate a private key & public cert with ECDSA.
openssl ecparam -genkey -name prime256v1 | openssl ec -out ${HOME}/.minio/certs/private.key
sudo echo """
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = US
ST = VA
L = Somewhere
O = MyOrg
OU = MyOU
CN = MyServerName

[v3_req]
subjectAltName = @alt_names

[alt_names]
IP.1 = 192.168.3.73
DNS.1 = localhost
""" > ${HOME}/.minio/certs/openssl.conf
## 一次生成秘钥和证书 
openssl req -new -x509 -nodes -days 3650 -keyout ${HOME}/.minio/certs/private.key -out ${HOME}/.minio/certs/public.crt -config ${HOME}/.minio/certs/openssl.conf

## 生成随机字符串作为密码
access_key=$(cat /dev/urandom | tr -dc '(\&\_a-zA-Z0-9\^\*\@' | fold -w ${1:-32} | head -n 1)

## 以容器启动
sudo podman run \
  --detach \
  --name=minio-server \
  -e MINIO_ROOT_USER=$MINIO_ROOT_USER \
  -e MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD \
  -e cap_net_bind_service=+ep \
  -v ${HOME}/.minio:/root/.minio \
  -v $mount_stand:/data:z \
  --network=host \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  quay.io/minio/minio:latest gateway nas /data --console-address ":9001"

## 以POD启动
sudo podman run \
  --detach \
  --pod=new:minio \
  --name=minio-server-pod \
  -e MINIO_ROOT_USER=$MINIO_ROOT_USER \
  -e MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD \
  -e cap_net_bind_service=+ep \
  -v ${HOME}/.minio:/root/.minio \
  -v $mount_stand:/data:z \
  --network=bridge \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  quay.io/minio/minio:latest gateway nas /data --console-address ":9001"


# Fileserver https://caddyserver.com/docs/

# LabelStudio
podman run -d -it -p 8080:8080 -v `pwd`/labelDatasets:/label-studio/data heartexlabs/label-studio:latest