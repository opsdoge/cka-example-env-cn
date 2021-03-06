#!/bin/sh
apt-get update
apt-get install -y etcd-client

kubeadm reset -f
kubeadm config images pull --kubernetes-version=stable-1.16.3 --image-repository=gcr.azk8s.cn/google_containers
kubeadm init --image-repository=gcr.azk8s.cn/google_containers --kubernetes-version=stable-1.16.3 --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=$POD_NW_CIDR
kubeadm token create --print-join-command --ttl 0 > /vagrant/tmp/master-join-command.sh

mkdir -p $HOME/.kube
sudo cp -Rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo cp $HOME/.kube/config /vagrant/tmp/kubeconfig_admin

cp /vagrant/certs/id_rsa /root/.ssh/id_rsa
cp /vagrant/certs/id_rsa.pub /root/.ssh/id_rsa.pub
chmod 400 /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa.pub

# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
curl -fsSL "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" -o /vagrant/scripts/resources/weave.yaml
sed -e "s/docker.io/dockerhub.azk8s.cn/" -i /vagrant/scripts/resources/weave.yaml
kubectl apply -f /vagrant/scripts/resources/weave.yaml