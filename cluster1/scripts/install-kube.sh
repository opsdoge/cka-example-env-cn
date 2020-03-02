#!/bin/sh

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

sed -e "s/archive.ubuntu.com/mirrors.aliyun.com/" -i /etc/apt/sources.list
sed -e "s/security.ubuntu.com/mirrors.aliyun.com/" -i /etc/apt/sources.list

apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni
apt-get autoremove -y
systemctl daemon-reload

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb [arch=amd64] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y docker.io kubelet=1.16.3-00 kubeadm=1.16.3-00 kubectl=1.16.3-00 kubernetes-cni nfs-common
apt-mark hold docker.io kubelet kubeadm kubectl kubernetes-cni
systemctl enable kubelet && systemctl start kubelet

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"],
  "log-driver": "json-file",
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/", "https://registry.docker-cn.com"]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl enable docker && systemctl start docker

docker info | grep overlay
docker info | grep systemd

exit 0
