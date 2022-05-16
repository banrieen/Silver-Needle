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

### MinIO Kubernetes Plugin
https://docs.min.io/minio/k8s/reference/minio-kubectl-plugin.html

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
ACCESS_KEY=$(cat /dev/urandom | tr -dc '(\&\_a-zA-Z0-9\^\*\@' | fold -w ${1:-32} | head -n 1)
SECRET_KEY=$(cat /dev/urandom | tr -dc '(\&\_a-zA-Z0-9\^\*\@' | fold -w ${1:-64} | head -n 1)

## Minio for local S3 storage using podman
## https://engineering.konveyor.io/posts/minio-for-local-s3/
### 以容器启动

sudo podman run \
  --detach \
  --name=minio-server \
  -e MINIO_ROOT_USER=$MINIO_ROOT_USER \
  -e MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD \
  -e MINIO_ACCESS_KEY=$ACCESS_KEY \
  -e MINIO_SECRET_KEY=$SECRET_KEY \
  -e cap_net_bind_service=+ep \
  -v ${HOME}/.minio:/root/.minio \
  -v $mount_stand:/data:z \
  --network=host \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  quay.io/minio/minio:latest gateway nas /data --console-address ":9001"

### 以POD启动
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

## Test MinIO
https://firepress.org/en/the-complete-guide-to-attach-a-docker-volume-with-minio-on-your-docker-swarm-cluster/

# Fileserver https://caddyserver.com/docs/

# LabelStudio
podman run -d -it -p 8080:8080 -v `pwd`/labelDatasets:/label-studio/data heartexlabs/label-studio:latest

## using MinIO Client mc

### mc alias set mynas http://gateway-ip:9000 access_key secret_key
sudo podman run minio/mc ls play

### mc alias set <ALIAS> <YOUR-S3-ENDPOINT> <YOUR-ACCESS-KEY> <YOUR-SECRET-KEY> --api <API-SIGNATURE> --path <BUCKET-LOOKUP-TYPE>
### mc alias set minio http://192.168.1.51 BKIKJAA5BMMU2RHO6IBB V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12

## Volume

sudo podman volume create --driver=local --opt device=/data/diska/data2vec/ data2vec

sudo podman  volume ls

# sudo podman  volume prune

## Volumes and rootless Podman
### https://blog.christophersmart.com/2021/01/31/volumes-and-rootless-podman/

## k8s operator
https://thenewstack.io/how-minio-brings-object-storage-service-to-kubernetes/

## Postgres 数据库

sudo podman run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

mkdir -p FileSpace

sudo podman --log-level=debug  run -dt \
--name postgres-test \
-v "$HOME/FileSpace:/var/lib/postgresql/data:Z" \
-e POSTGRES_PASSWORD=pr0pm \
-e POSTGRES_USER=pr0pm \
-p 5432:5432 \
-p 9876:80 \
 postgres


## 数据库客户端pgadmin
pip install pgadmin
pgadmin4
mail:haiyuan.bian@apulis.com
passwd:abc@123456

##===============================================
import psycopg2

conn = psycopg2.connect(database="postgres", user="postgres", password="pr0pm", host="192.168.3.73", port="9432")
print("Opened database successfully")

cur = conn.cursor()
cur.execute("SELECT name, threshhold0, threshhold1  from sjy_aqi_threshhold")
rows = cur.fetchall()
for row in rows:
   print("NAME = ")
   print("threshhold0 = ")
   print("threshhold0 = ")
print("Operation done successfully")
conn.close()

