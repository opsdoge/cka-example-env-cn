#!/bin/sh

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

echo "modify apt source mirror"
sed -e "s/archive.ubuntu.com/mirrors.ustc.edu.cn/" -i /etc/apt/sources.list
sed -e "s/security.ubuntu.com/mirrors.ustc.edu.cn/" -i /etc/apt/sources.list

echo "remove old package"
apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni
apt-get autoremove -y
systemctl daemon-reload

echo "add k8s repo key"
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

echo "add k8s repo"
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb [arch=amd64] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

echo "install k8s packages"
apt-get update
apt-get install -y docker.io kubelet=1.16.3-00 kubeadm=1.16.3-00 kubectl=1.16.3-00 kubernetes-cni nfs-common
apt-mark hold docker.io kubelet kubeadm kubectl kubernetes-cni
systemctl enable kubelet && systemctl start kubelet

echo "modify daemon.json"
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/", "https://registry.docker-cn.com"]
}
EOF

echo "set docker proxy"
mkdir -p /etc/systemd/system/docker.service.d

# cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
# [Service]
# Environment="HTTP_PROXY=$HTTP_PROXY"
# EOF

# cat > /etc/systemd/system/docker.service.d/https-proxy.conf <<EOF
# [Service]
# Environment="HTTPS_PROXY=$HTTP_PROXY"
# EOF

# cat > /etc/systemd/system/docker.service.d/no-proxy.conf <<EOF
# [Service]    
# Environment="$NO_PROXY"
# EOF

# Restart docker.
systemctl daemon-reload
systemctl enable docker && systemctl start docker

docker info | grep overlay
docker info | grep systemd

exit 0