# Kubernetes CKA Example Environments

基于[Kubernetes CKA Example Environments](https://github.com/wuestkamp/cka-example-environments)。根据国内的网络环境进行了修改，apt source 及 k8s 各组件安装使用阿里云镜像站，1.16版本后 kubeadm 的 `--image-repository` 参数可自定义控制平面安装的镜像仓库，使用 Azure 国内镜像站 `gcr.azk8s.cn` 替换官方 `k8s.gcr.io`，保证整个环境在无科学上网条件下的部署。

## setup and run

提供两节点的 Kubernetes Cluster 环境，一个 master，一个 worker。Kubernetes 版本 1.6.3，适配当前 CKA 考试版本。增加 worker，或提高虚拟机配置，请编辑 `cluster1/Vagrantfile`

在以下环境中测试通过：
- OS：
    - macOS Catalina
    - Ubuntu 18.04
    - Windows 10
- Virtualbox 6.1
- Vagrant 2.2.7

运行：
```
git clone https://github.com/opsdoge/cka-example-env-cn.git
cd cka-example-env-cn/cluster1
vagrant up

vagrant ssh cluster1-master1
vagrant@cluster1-master1:~$ sudo -i
root@cluster1-master1:~# kubectl get node
```

Windows 用户在 Powershell 下直接运行 `vagrant ssh` 无效，需要先作以下设置:
```
$env:VAGRANT_PREFER_SYSTEM_BIN="0"
```

`vagrant up` 过程中会下载 `ubuntu/bionic64` 这个 box，国内网络环境下可能下载速度不佳，可以选择通过清华大学的开源镜像站下载后，手工添加 box：
```
wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cloud-images/bionic/current/bionic-server-cloudimg-amd64-vagrant.box
vagrnat box add ubuntu/bionic64 bionic-server-cloudimg-amd64-vagrant.box
```
再进行 `vagrant up` 及后续操作。
