#!/bin/sh

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni
apt-get autoremove -y
systemctl daemon-reload

sed -e "s/http\:\/\/archive.ubuntu.com/https\:\/\/mirrors.aliyun.com/" -i /etc/apt/sources.list
sed -e "s/http\:\/\/security.ubuntu.com/https\:\/\/mirrors.aliyun.com/" -i /etc/apt/sources.list

curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb [arch=amd64] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y docker-ce=18.06.2~ce~3-0~ubuntu

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/", "https://dockerhub.azk8s.cn"]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl enable docker && systemctl restart docker

docker info | grep overlay
docker info | grep systemd

apt-get install -y kubelet=1.16.3-00 kubeadm=1.16.3-00 kubectl=1.16.3-00 kubernetes-cni nfs-common
apt-mark hold docker-ce kubelet kubeadm kubectl kubernetes-cni
systemctl enable kubelet && systemctl restart kubelet

exit 0
