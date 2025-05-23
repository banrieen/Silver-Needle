# 组建性能自动化测试服务

## 性能测试服务器初始化






##     Upgrade GPU Driver
https://en.opensuse.org/SDB:NVIDIA_drivers#:~:text=Procedure%201%20Add%20the%20Nvidia%20Repository.%20The%20NVIDIA,your%20hardware%20information%20into%20Nvidia%27s%20driver%20search%20engine.

## Enable SSH
https://en.opensuse.org/SDB:OpenSSH_basics#:~:text=OpenSSH%2C%20SSHD%2C%20is%20installed%20in%20openSUSE%20by%20default.,it%20to%20the%20list.%20Save%20configuration%20and%20exit.


## Revert network manager to wicked

https://doc.opensuse.org/documentation/leap/reference/html/book-reference/cha-network.html#sec-network-nm

## Config network config 
https://unix.stackexchange.com/questions/280552/static-ip-configuration-on-opensuse


## Install application (font, browser, editor, screenshot)

* 参考


[使用 docker 或 k8s 执行测试](https://docs.locust.io/en/stable/running-locust-docker.html)


0. 集群配置


|角色    |访问链接                                                |业务账号      |管理IP        |管理账号      |
|:------:|:------------------------------------------------------:|:------------:|:------------:|-------------:|
|master  | sshpass -p apulis@2025 ssh -p 2025 root@192.168.1.204  |root/Aiops@18c|192.168.1.17  |ADMIN/apulis18c|
|worker01| sshpass -p apulis@2025 ssh -p 2025 root@192.168.1.217  |root/Aiops@18c|192.168.1.21  |默认 |
|dev env | local                                                  |root/Aiops@18c|192.168.1.15  |默认 |

* Remote Desktop: ssh Admin@192.168.1.x

ip route add default via 192.168.1.1 dev eth0 proto static metric 100

* frp proxy:
+ perf-server： 
- kubernetes dashboard： https://<HOST>:30692/#/login

```bash
eyJhbGciOiJSUzI1NiIsImtpZCI6ImR6S05ENHB4QlRqNmcxcjhzNEdSc1hGeVhWWWtvZlktSkQ4V2lHODJVNmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbWQ1ZzgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGEwMWE5NzAtZGFlMS00ZmE2LTgzMjYtOTgyZDVlMTZlZjM1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.NphmgVFtBzzWSHDRYcEzgcqER3IJcFP8FTd9fuUZGaaVow1eOoTAR5QiGpTMaKrg8HM4VBJKB368tbp-eCxFFbSp3HxZuwRUqwPMAAHSrp5dEshTeuk3S-m7CwACu0n77pWnURX8Xs3Q9ksbvCLxEySjQrcPOltdll0lY2bjK2z5NRLBAraaD6-9J-vOySAC5p6K6awh_ODGDNE8WhPuRPRmfL4qG58DEz3Wk7wUTv0Pix7IcjOHjjkJCYEIMDmS_Hu3w8oagMFpQxU88PPNTXk5aIXXS7beFOCXN_zz-nLW2A_h5ST9wftU3-PWGNtajTQZzZEyNyHOAJgqVgUmeg
```
- argo: http://<HOST>:30184/workflows/
+ test-env：
- kubernetes dashboard：https://<HOST>:32109/#/login

```bash
eyJhbGciOiJSUzI1NiIsImtpZCI6IlZ6UzJaWEtScFYxYTBmZ2o3bW0yZDdtWWZNTVJuX0w5TXMwRWxsc0ZvMkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ3ZWF2ZS1uZXQtdG9rZW4tczZrNmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoid2VhdmUtbmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTFhYWNjNDItZTk0ZS00YjIzLWE5YWUtYmE1NmZmY2QyNzk3Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOndlYXZlLW5ldCJ9.o0m-U3Ur0nxxdjj8l3Wu7vLSHU9iJQsi3_vYysq3NyOURjoC-IiEOMu4vgp3ITClsh-i6dxFrURdis-wH2bFwP31Bnz5UScor6iNCHSFwaZ7f_oGlkcgqCXBNvvhX2kuVZgs12UT0jHXxhKvRNXzUEVYoS0XnmiGY04ICHFPxdo0tnclI4pb20cGl1bTGHXh0HcZkaN-UJIwHRxt7jNd7OoOeXL4hE9BY1TAIkPKt4a9Uz7Bg-kWnp3V87czZwv38eyy76oqr7HVjuRvOiDEsHwi4jyU76Nd-Plhl6bIxHZpIolTfYRBgMqQG6e3mDTrp6oK3A6bSS_DxiRE2tNxqA
```
- apulis-platform: http://<HOST>:7080/AIarts/codeDevelopment (thomas/apulis@2025)
- apulis-endpoint: http://<HOST>:7080/endpoints/eyJwb3J0IjoiTXpJeE1EST0iLCJ1c2VyTmFtZSI6InRob21hcyJ9/lab

1. 系统安装和配置

   * 安装 15.2 lTS 

   + 基础网络配置:

    ```bash
    # 配置IP:

    NAME=''
    BOOTPROTO='static' # 'dhcp'
    STARTMODE='auto'
    ZONE=''
    IPADDR='192.168.1.240/24'

    # 配置路由：
    vim /etc/sysconfig/network/ifroute-eth0
    default 192.168.1.1 - eth0

    # 配置DNS：
    vim /etc/sysconfig/network/config
    NETCONFIG_DNS_STATIC_SERVERS="114.114.114.114"
    NETCONFIG_DNS_STATIC_SEARCHLIST="114.114.114.114"

    systemctl restart network
    ```

   * 更新安装源：

    ```bash
    sudo mkdir -p /etc/zypp/repos.d/repo.bak
    sudo mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo.bak/
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/ OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/ NON-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/ UPDATE-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/ UPDATE-NON-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/packman/suse/openSUSE_Leap_15.2 PACKMAN
    zypper ref
    ```
    
    ```bash
    vim /etc/yum.repos.d/kube.repo

    [kubernetes]
    name=kubernetes
    enabled=1
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    gpgcheck=1
    gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg

    # 安装证书
    wget https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    rpm --import rpm-package-key.gpg
    ```

2. opensuse 设置系统代理

Global proxy configuration
Please edit /etc/sysconfig/proxy with the following proxy values:

    ```
    PROXY_ENABLED="yes"
    HTTP_PROXY="http://192.168.0.1:8899"
    HTTPS_PROXY="http://192.168.0.1:8899"
    FTP_PROXY="http://192.168.0.1:8899"
    NO_PROXY="localhost, 127.0.0.1"
    ```

3. 安装docker
    ```bash
    zypper in docker
    systemctl restart docker
    systemctl enable docker
    ```
4. modprobe & sysctl
   
    ```bash
    modprobe overlay
    modprobe br_netfilter

    Edit /etc/sysctl.conf:

    net.ipv4.ip_forward = 1
    net.ipv4.conf.all.forwarding = 1
    net.bridge.bridge-nf-call-iptables = 1

    Run this command to apply:

    sysctl -p  
    ```

* 解决 docker 报错: `Error starting daemon: error initializing graphdriver: backing file system is unsupported for this graph driver`
发现了关键字:   graphdriver=btrfs 以及之前的报错有提示:  `error msg="'overlay2' requires kernel 4.7 to use on btrfs"`

    ```bash
    # 所以尝试修改 /etc/sysconfig/docker-storage 为:
    DOCKER_STORAGE_OPTIONS="--storage-driver btrfs "

    # 重新启动docker: 

    systemctl restart docker.service

    # opensuse 默认文件系统为 btrfs
    cat /proc/filesystems | grep btrfs

    df -Th
    /dev/mapper/data_vg-var            btrfs      **G  407M   **G   1% /var
    /dev/mapper/data_vg-var_lib        btrfs      **G  232M   **G   1% /var/lib
    /dev/mapper/data_vg-var_lib_docker btrfs      **G   17M   **G   1% /var/lib/docker

    sudo cat /proc/filesystems | grep btrfs

        btrfs
    # docker 默认overlay2
    # "storage-driver": "overlay2" 
    # Edited /etc/docker/daemon.json as below

    {
    "storage-driver": "btrfs"
    }

    ```

* 切换docker 文件系统为btrfs

    *https://docs.docker.com/storage/storagedriver/btrfs-driver/*

    1. 查看系统的文件类型

    grep btrfs /proc/filesystems
    btrfs

    2. 停止docker

    systemctl stop docker.service

    4. 格式化docker文件系统目录
    
      ```bash
      mkfs.btrfs -f /dev/sda
      # 查看未挂载的文件系统类型
      lsblk -f
      mkfs.btrfs -f /dev/sda1
      mkfs.btrfs -f /dev/sda2
      ```
    1. 挂在目录到 /var/lib/docker

    一般将 docker 文件系统挂在系统盘之外的存储空间，避免影响到系统和k8s稳定性
    如果是RAID，需要创建目录或划分区;如果是独立硬盘建议划分区
    sudo mount -t btrfs /dev/sda1 /var/lib/docker
    mount /dev/sda2 /mnt/fd
    sudo mount -t btrfs /dev/sda1 /var/lib/docker

    /dev/sda2      btrfs     500G  3.8M  498G   1% /mnt/fd
    /dev/sda1      btrfs     432G  3.7G  427G   1% /var/lib/docker


    + 永久挂载

    vim /etc/fstab
    `UUID=27d8f541-30d1-4e78-b798-bd8f683ff337  /var/lib/docker      btrfs     defaults        0      0`
    `UUID=3122d2a7-22fc-4c56-9e57-ce0a544f03f1  /mnt/fd      btrfs     defaults        0      0`

5. 安装 k8s

   1. ADD k8s Repository

    cat <<EOF > /etc/zypp/repos.d/google-k8s.repo
    [google-k8s]
    name=google-k8s
    enabled=1
    autorefresh=1
    #baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    type=rpm-md
    gpgcheck=1
    repo_gpgcheck=1
    pkg_gpgcheck=1
    EOF

   2. 如果是goolge源，Add gpg key for repository, run command:

    rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg

   3. Refresh repository, run command:

    zypper refresh google-k8s

    Install kubeadm,kubectl & kubelet

4. Install a bundling package to completed your kubernetes cluster:

    `zypper in kubelet  kubernetes-cni kubeadm  cri-tools kubectl  socat`

    Ignoring conntrack breakout, just pick:
    ```
    Solution 2: break kubelet-1.15.4-0.x86_64 by ignoring some of its dependencies Choose from above solutions by number or skip, retry or cancel [1/2/s/r/c] (c): 2 ...

    Solution 3: break kubelet-1.13.3-0.x86_64 by ignoring some of its dependencies Choose from above solutions by number or skip, retry or cancel [1/2/3/s/r/c] (c): 3
    ```

5. 使用kubeadm 初始化k8s集群

* 生成初始化配置
kubeadm config print init-defaults > kubeadm-config.yaml
修改脚本中的：advertiseAddress：为本机IP
             imageRepository：ali源<registry.cn-hangzhou.aliyuncs.com/google_containers>
其他需要指定的：
    --kubernetes-version    #指定Kubernetes版本
    --pod-network-cidr    #指定pod网络段
    --service-cidr    #指定service网络段
    --ignore-preflight-errors=Swap    #忽略swap报错信息

* 指定配置

kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs

kubeadm init --config=kubeadm-config.yaml --pod-network-cidr=10.244.14.0/16 --ignore-preflight-errors=all --upload-certs --v=6 

kubeadm init --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.14.0/16 --ignore-preflight-errors=all --upload-certs --v=6 

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf


`rm -rf $HOME/.kube/config && rm -rf /etc/cni/net.d`

* k8s 不支持swap 需要关闭
  sudo swapoff -a 
vim /etc/fstab 将swap注释
* 提示文件系统不支持DOCKER_GRAPH_DRIVER: btrfs

--ignore-preflight-errors=all 

6. 查看集群状态
kubectl get pods --all-namespaces --watch
如果有组建比如coredns 状态为pending，则要按照网络组件，推荐weavenet

4.2. 安装weave 网络组建

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sysctl net.bridge.bridge-nf-call-iptables=1

docker pull docker.io/weaveworks/weave-npc:2.7.0
docker pull docker.io/weaveworks/weave-kube:2.7.0

7. 加入worker节点

kubeadm join 192.168.99.101:6443 --token x8wb20.f8czwt7sdxbvprdh --discovery-token-ca-cert-hash sha256:5226d23fa710d7ca86443ca52665c5b7d0526aced2985da4b88b3cfdcd0deb97


**备份软件包**

zypper --pkg-cache-dir /tmp install --download-only --no-recommends

* 参考链接

https://nugi.abdiansyah.com/how-to-kubernetes-in-opensuse-leap-15-1-hardest-way/
https://en.opensuse.org/Kubic:kubeadm
https://stackoverflow.com/questions/62795930/how-to-install-kubernetes-in-suse-linux-enterprize-server-15-virtual-machines


* 默认情况下master 不负载，设置master也可以创建pod
kubectl get nodes
NAME    STATUS   ROLES                  AGE   VERSION
tomas   Ready    control-plane,master   62m   v1.20.1

kubectl taint nodes tomas node-role.kubernetes.io/master-
node/tomas untainted

    + 参考：https://www.cnblogs.com/riseast/p/12938434.html



## 部署argo

    ```
    docker pull argoproj/argocli:v2.12.2
    docker pull minio/minio:RELEASE.2019-12-17T23-16-33Z

    docker pull argoproj/workflow-controller:v2.12.2
    docker pull postgres:12-alpine
    https://github.com/argoproj/argo/

    kubectl create namespace argo
    wget https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml .
    kubectl apply -n argo -f ./install.yam
    ```

* `Connecting to raw.githubusercontent.com failed: Connection refused.`
    查询raw.githubusercontent.com的真实IP
    在https://www.ipaddress.com/ 查询raw.githubuercontent.com的真实IP。

    修改hosts
    在/etc/hosts/中绑定查到的host，例如：

    sudo vim /etc/hosts
    #绑定host
    199.232.28.133 raw.githubusercontent.com

* 参考： https://www.jianshu.com/p/5c1a352ba242

* argo cli

    ```
    # Download the binary
    curl -sLO https://github.com/argoproj/argo/releases/download/v2.12.7/argo-linux-amd64.gz

    # Unzip
    gunzip argo-linux-amd64.gz

    # Make binary executable
    chmod +x argo-linux-amd64

    # Move binary to path
    mv ./argo-linux-amd64 /usr/local/bin/argo

    # Test installation
    argo version
    ```


### 创建 ConfigMap

    ConfigMap 允许你将配置文件与镜像文件分离，以使容器化的应用程序具有可移植性。

    ```bash
    kubectl create configmap <map-name> <data-source>
    ```

**附：**

* 设置office365邮箱登录

点击文件 >账户设置 >账户设置 > 新建 > 输入账号后选择高级选项 > 手动设置账户 > 连接  > 然后按照您的参数进行配置并配置成功。

IMAP:
服务器：outlook.office365.com
端口：993
加密：TLS

SMTP:
服务器：smtp.office365.com
端口：587
加密：STARTTLS

* 备份数据：

docker save -o perf-argocli.tar                     argoproj/argocli:v2.12.2                       
docker save -o perf-workflow-controller.tar         argoproj/workflow-controller:v2.12.2                        
docker save -o perf-kube-proxy.tar                  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.20.1                       
docker save -o perf-kube-controller-manager.tar     registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.20.1                       
docker save -o perf-kube-apiserver.tar              registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.20.1                       
docker save -o perf-kube-scheduler.tar              registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.20.1                        
docker save -o perf-postgres.tar                    postgres:12-alpine                      
docker save -o perf-unifi-controller.tar            linuxserver/unifi-controller:latest                         
docker save -o perf-etcd.tar                        registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.4.13-0                       
docker save -o perf-weave-npc.tar                   weaveworks/weave-npc:2.7.0                          
docker save -o perf-weave-kube.tar                  weaveworks/weave-kube:2.7.0                          
docker save -o perf-coredns.tar                     registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.7.0                          
docker save -o perf-pause.tar                       registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2                            
docker save -o perf-minio.tar                       minio/minio:RELEASE.2019-12-17T23-16-33Z  



## 本地部署 mock-server


* 可用的在线mock
[beeceptor](https://beeceptor.com/)
[swaggerhub](https://app.swaggerhub.com/apis/jamesdbloom/mock-server-openapi/5.11.x)
[stoplight](https://stoplight.io/welcome/)

* stoplight account

  + name: thomas.bian 
  + passwd: apulis@2025
* beeceptor
  + 2779026762@qq.com
  + apulis@2025
  + baseurl: https://apulis.free.beeceptor.com

1. 创建环境目录

```bash
mkdir -p /opt/mockserver
mkdir -p /opt/mockserver/config
docker pull mockserver/mockserver
docker-compose up -d
```

2. 本地docker-compose

```yaml
version: "2.4"
services:
  mockServer:
    image: mockserver/mockserver:latest
    ports:
      - 1080:1080
    environment:
      MOCKSERVER_PROPERTY_FILE: /opt/config/mockserver.properties
      MOCKSERVER_INITIALIZATION_JSON_PATH: /opt/config/initializerJson.json
    volumes:
      - type: bind
        source: .
        target: /config
```


3. 配置

```bash
# conf mockserver.properties
###############################
# MockServer & Proxy Settings #
###############################

# Socket & Port Settings
# socket timeout in milliseconds (default 120000)
mockserver.maxSocketTimeout=120000

# Certificate Generation

# dynamically generated CA key pair (if they don't already exist in specified directory)
mockserver.dynamicallyCreateCertificateAuthorityCertificate=true
# save dynamically generated CA key pair in working directory
mockserver.directoryToSaveDynamicSSLCertificate=.
# certificate domain name (default "localhost")
mockserver.sslCertificateDomainName=localhost
# comma separated list of ip addresses for Subject Alternative Name domain names (default empty list)
mockserver.sslSubjectAlternativeNameDomains=www.example.com,www.another.com
# comma separated list of ip addresses for Subject Alternative Name ips (default empty list)
mockserver.sslSubjectAlternativeNameIps=127.0.0.1

# CORS

# enable CORS for MockServer REST API
mockserver.enableCORSForAPI=true
# enable CORS for all responses
mockserver.enableCORSForAllResponses=true
```

4. 接口配置 

```json initializerJson.json
[
  {
    "httpRequest": {
      "path": "/json"
    },
    "httpResponse": {
      "body": "some response"
    }
  },
  {
    "httpRequest": {
      "path": "/secondExampleExpectation"
    },
    "httpResponse": {
      "body": "some response"
    }
  }
]
```

**参考**

1. [mock-server-docker_container](https://www.mock-server.com/mock_server/running_mock_server.html#docker_container)
1. 


## 集成swagger


* Running the image from DockerHub

There is a docker image published in DockerHub.To use this, run the following:

```bash
docker pull swaggerapi/swagger-editor
docker run -d -p 80:8080 swaggerapi/swagger-editor
```

This will run Swagger Editor (in detached mode) on port 80 on your machine, so you can open it by navigating to http://localhost in your browser.

You can provide your own json or yaml definition file on your host

`docker run -d -p 80:8080 -v $(pwd):/tmp -e SWAGGER_FILE=/tmp/swagger.json swaggerapi/swagger-editor`

You can provide a API document from your local machine — for example, if you have a file at ./bar/swagger.json:

`docker run -d -p 80:8080 -e URL=/foo/swagger.json -v /bar:/usr/share/nginx/html/foo swaggerapi/swagger-editor`

You can specify a different base url at which where to access the application - for example if you want to application to be available at http://localhost/swagger-editor/:

`docker run -d -p 80:8080 -e BASE_URL=/swagger-editor swaggerapi/swagger-editor`

* configuration

+ host: 192.168.1.204
+ conf: /opt/swagger
+ port: 8180
+ path: /swagger-editor
+ start_cmd: `docker run -d --restart unless-stopped -p 8180:8080 -e BASE_URL=/swagger-editor swaggerapi/swagger-editor`
---

* Refer:
1. [swagger_github](https://github.com/swagger-api/swagger-editor)


## 内网穿透实例 FRP


为什么使用 frp ？
通过在具有公网 IP 的节点上部署 frp 服务端，可以轻松地将内网服务穿透到公网，同时提供诸多专业的功能特性，这包括：

客户端服务端通信支持 TCP、KCP 以及 Websocket 等多种协议。
采用 TCP 连接流式复用，在单个连接间承载更多请求，节省连接建立时间。
代理组间的负载均衡。
端口复用，多个服务通过同一个服务端端口暴露。
多个原生支持的客户端插件（静态文件查看，HTTP、SOCK5 代理等），便于独立使用 frp 客户端完成某些工作。
高度扩展性的服务端插件系统，方便结合自身需求进行功能扩展。
服务端和客户端 UI 页面。

1. frp 服务器，客户端配置

分别在公网服务器和私网终端下载[frp包](https://github.com/fatedier/frp/releases)，根据如下配置server,client。

这个示例通过简单配置 TCP 类型的代理让用户访问到内网的服务器。

**通过 SSH 访问内网机器: **

1.1. 服务器端 frps.ini

```
[common]
bind_port = 7000
dashboard_port = 7500
token = 12345678
dashboard_user = admin
dashboard_pwd = admin
vhost_http_port = 10080
vhost_https_port = 10443
```

**其中**

  * “bind_port”表示用于客户端和服务端连接的端口，这个端口号我们之后在配置客户端的时候要用到。
  * “dashboard_port”是服务端仪表板的端口，若使用7500端口，在配置完成服务启动后可以通过浏览器访问 x.x.x.x:7500 （其中x.x.x.x为VPS的IP）查看frp服务运行信息。
  * “token”是用于客户端和服务端连接的口令，请自行设置并记录，稍后会用到。
  * “dashboard_user”和“dashboard_pwd”表示打开仪表板页面登录的用户名和密码，自行设置即可。
  * “vhost_http_port”和“vhost_https_port”用于反向代理HTTP主机时使用，本文不涉及HTTP协议，因而照抄或者删除这两条均可。


1.2. 客户端frp.ini

*如果有多个终端使用相同的协议比如ssh连接，需要设置为不同的服务名称，例如:[ssh_client1],[ssh_client2]*

```
[common]
server_addr = x.x.x.x
server_port = 7000
token = won517574356
[rdp]
type = tcp
local_ip = 127.0.0.1   
local_port = 3389
remote_port = 7001
[ssh_other]
type = tcp
local_ip = 127.0.0.1   
local_port = 22
remote_port = 7022  
[smb]
type = tcp
local_ip = 127.0.0.1
local_port = 445
remote_port = 7002
```
其中common字段下的三项即为服务端的设置。

“server_addr”为服务端IP地址，填入即可。
“server_port”为服务器端口，填入你设置的端口号即可，如果未改变就是7000
“token”是你在服务器上设置的连接口令，原样填入即可。
2. 开机自启动服务配置

我服务文件都弄好了，放到 /etc/systemd/system（供系统管理员和用户使用），/usr/lib/systemd/system（供发行版打包者使用）了

* 在服务器端使用 Systemd 管理 frps

  ```bash
  # 需要先 cd 到 frp 解压目录.

  # 复制文件
  cp frps /usr/local/bin/frps
  mkdir /etc/frp
  cp frps.ini /etc/frp/frps.ini

  # 编写 frp service 文件，以 ubuntu 为例
  vim /etc/systemd/system/frps.service (有时候需要手动创建system文件夹)
  # 内容如下
  [Unit]
  Description=frps
  After=network.target

  [Service]
  TimeoutStartSec=30
  ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
  ExecStop=/bin/kill $MAINPID
  Restart=on-failure
  RestartSec=30s
  KillMode=none


  [Install]
  WantedBy=multi-user.target

  # 启动 frp 并设置开机启动
  systemctl stop frps
  systemctl disable frps
  systemctl start frps
  systemctl enable frps
  systemctl status frps

  # 部分服务器上,可能需要加 .service 后缀来操作,即:
  systemctl enable frps.service
  systemctl start frps.service
  systemctl status frps.service
  ```
* 在客户端使用 Systemd 管理 frpc

  ```bash
  # 需要先 cd frp 解压目录.

  # 复制文件
  cp frpc /usr/local/bin/frpc
  mkdir /etc/frp
  cp frpc.ini /etc/frp/frpc.ini

  # 编写 frp service 文件，以 centos7 为例,适用于 debian
  vim /etc/systemd/system/frpc.service
  # 内容如下
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

  # 启动 frp 并设置开机启动
sudo systemctl stop frpc
sudo systemctl disable frpc
sudo systemctl start frpc
sudo systemctl enable frpc
sudo systemctl status frpc
  ```

* 参考链接：

1. [github](https://github.com/fatedier/frp)
2. [中文文档](https://gofrp.org/docs/setup/)
3. [systemd example](https://www.jianshu.com/p/ea7dec93ee92)
4. [systemd example2](https://zhuanlan.zhihu.com/p/80908971)
5. [frpc.ini example](https://sspai.com/post/52523)
6. [Opensuse Systemd service](https://zh.opensuse.org/openSUSE:How_to_write_a_systemd_service)



## Kubernetes Mstrics Server 配置

  **生成整个文件加的所有文件md5 到checksums.md5**

  ```bash
  apt install -y md5deep
  md5deep -rel -o f . >> ./checksums.md5
  ```

**更新**

```bash
#!/bin/bash
k8s.gcr.io/metrics-server/metrics-server:v0.4.1
# registry.aliyuncs.com/google_containers/metrics-server/metrics-server:v0.4.1
kubectl edit deployment -n kube-system metrics-server
```

> /etc/hosts 中 127.0.0.1 localhost 不能注释否则calico起不来

**安装jupyter 插件**

`pip install xeus-python notebook  -i https://pypi.tuna.tsinghua.edu.cn/simple`

**安装ZFS**

```bash
zypper addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Leap_15.2/filesystems.repo
zypper refresh
zypper install zfs
```


## Installation


### metrix-server

```bash
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# 在 container 下添加 - --kubelet-insecure-tls
kubectl apply -f ./components.yaml
kubectl get deployment metrics-server -n kube-system
kuber-dashboard
```

> ```
> echo subjectAltName = IP:worker_node_ip > extfile.cnf
> openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
> ```

### Kubernetes Dashboard

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml`

**local access :**

`kubectl  get svc -n kubernetes-dashboard`

```
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
```

**安装helm**

`zypper install helm`

+ Initialize a Helm Chart Repository
  helm repo add stable https://charts.helm.sh/stable
  helm search repo stable

### 备份metrix-server

docker save -o metrics-server-v0.4.1.tar k8s.gcr.io/metrics-server/metrics-server:v0.4.1
docker save -o kube-dashboard-v2.0.0-beta1.tar kubernetesui/dashboard:v2.0.0-beta1
docker save -o metrics-scraper-v1.0.0.tar kubernetesui/metrics-scraper:v1.0.0
docker save -o tigera-operator-v1.13.2.tar quay.io/tigera/operator:v1.13.2

### 停止pod

kubectl scale --replicas=0 deployment/dashboard-metrics-scraper -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-dashboard -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-metrics-scraper -n kubernetes-dashboard

kubectl scale --replicas=1 deployment/metrics-server -n kube-system

[how to stop/pause a pod in kubernetes](https://stackoverflow.com/questions/54821044/how-to-stop-pause-a-pod-in-kubernetes)

### 创建用户和账号

kubectl create serviceaccount dashboard-admin -n kube-system
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin -serviceaccount=kube-system:dashboard-admin
kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')

Name:         dashboard-admin-token-md5g8
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
kubernetes.io/service-account.uid: 0a01a970-dae1-4fa6-8326-982d5e16ef35

Type:  kubernetes.io/service-account-token


ca.crt:     1066 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImR6S05ENHB4QlRqNmcxcjhzNEdSc1hGeVhWWWtvZlktSkQ4V2lHODJVNmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbWQ1ZzgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGEwMWE5NzAtZGFlMS00ZmE2LTgzMjYtOTgyZDVlMTZlZjM1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.NphmgVFtBzzWSHDRYcEzgcqER3IJcFP8FTd9fuUZGaaVow1eOoTAR5QiGpTMaKrg8HM4VBJKB368tbp-eCxFFbSp3HxZuwRUqwPMAAHSrp5dEshTeuk3S-m7CwACu0n77pWnURX8Xs3Q9ksbvCLxEySjQrcPOltdll0lY2bjK2z5NRLBAraaD6-9J-vOySAC5p6K6awh_ODGDNE8WhPuRPRmfL4qG58DEz3Wk7wUTv0Pix7IcjOHjjkJCYEIMDmS_Hu3w8oagMFpQxU88PPNTXk5aIXXS7beFOCXN_zz-nLW2A_h5ST9wftU3-PWGNtajTQZzZEyNyHOAJgqVgUmeg

### 测试环境测试环境

```bash
root@master:/home/InstallationYTung# kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')
Name:         dashboard-admin-token-2znx2
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
kubernetes.io/service-account.uid: ce059793-5b3d-4236-8f95-9d5d6b56373c

Type:  kubernetes.io/service-account-token


token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlZ6UzJaWEtScFYxYTBmZ2o3bW0yZDdtWWZNTVJuX0w5TXMwRWxsc0ZvMkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ3ZWF2ZS1uZXQtdG9rZW4tczZrNmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoid2VhdmUtbmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTFhYWNjNDItZTk0ZS00YjIzLWE5YWUtYmE1NmZmY2QyNzk3Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOndlYXZlLW5ldCJ9.o0m-U3Ur0nxxdjj8l3Wu7vLSHU9iJQsi3_vYysq3NyOURjoC-IiEOMu4vgp3ITClsh-i6dxFrURdis-wH2bFwP31Bnz5UScor6iNCHSFwaZ7f_oGlkcgqCXBNvvhX2kuVZgs12UT0jHXxhKvRNXzUEVYoS0XnmiGY04ICHFPxdo0tnclI4pb20cGl1bTGHXh0HcZkaN-UJIwHRxt7jNd7OoOeXL4hE9BY1TAIkPKt4a9Uz7Bg-kWnp3V87czZwv38eyy76oqr7HVjuRvOiDEsHwi4jyU76Nd-Plhl6bIxHZpIolTfYRBgMqQG6e3mDTrp6oK3A6bSS_DxiRE2tNxqA
ca.crt:     1350 bytes
namespace:  11 bytes
```

* 设置访问端口
  kubectl get svc -n kubernetes-dashboard
  kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kubernetes-dashboard

root@master:/home/InstallationYTung# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.68.3.176   <none>        8000/TCP        18m
kubernetes-dashboard        NodePort    10.68.224.5   <none>        443:34549/TCP   18m


### Images list


**metrics-server: ** metrics-server-v0.4.1.tar (k8s.gcr.io/metrics-server/metrics-server:v0.4.1)


* 排查
endpoint:

kubectl get ep -A

 ds:
kubectl get ds -n kube-system

yaml 在/build 下面


## docker run postgres

```bash
docker run -d --restart unless-stopped  --name perf-postgres  -e POSTGRES_PASSWORD=Aiperf@2025  -e PGDATA=/var/lib/postgresql/data/pgdata  -v /opt/postgresql:/var/lib/postgresql/data   postgres:12-alpine
```