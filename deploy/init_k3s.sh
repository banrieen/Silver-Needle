

# 离线下载镜像
Images=k3s-airgap-images-amd64.tar.gz
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo wget https://github.91chi.fun//https://github.com//k3s-io/k3s/releases/download/v1.23.3%2Bk3s1/${Images} -o /var/lib/rancher/k3s/agent/images/${Images}

# 将 K3s 安装脚本和 K3s 二进制文件移动到对应目录并授予可执行权限
sudo su
sudo mkdir -p /root/k3s
cd /root/k3s
sudo wget https://github.91chi.fun//https://github.com//k3s-io/k3s/releases/download/v1.23.3%2Bk3s1/k3s -o k3s 
sudo curl -sfL https://get.k3s.io -o k3s-install.sh
sudo chmod a+x -R /root/k3s 
sudo cp /root/k3s/k3s /usr/local/bin/

INSTALL_K3S_SKIP_DOWNLOAD=true ./k3s-install.sh

# 查找并删除port进程
sudo kill -9 $(sudo lsof -t -i:8000)
kill -9 $(lsof -t -i:3000 -sTCP:LISTEN)`

# 禁用swap
sudo sed -i 's/swap   defaults               0  0/swap   defaults,noauto               0  0/' /etc/fstab
# k8s 仪表盘
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml

# Install rancher standalong
## Quick start
sudo podman run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher

sudo podman logs 76b3a376ac8b | grep "Bootstrap Password:"
## passwd: h6mcbs4l7565vvjb7lwtrsppz4h6fzlwwtztqdhgttxv5cggr4jrc6
## abc@1234567890

kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

