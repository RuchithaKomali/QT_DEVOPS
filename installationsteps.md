# Install kubernetes
------------------------

* to install k8s first we need to install docker and cri-dockerd
docker
```yaml
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $(whoami)
    exit
```
cri-dockerd(To install cri-dockerd we need git and go)

```yaml
sudo -i
###Install GO###
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
./installer_linux
source ~/.bash_profile
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
```
## Now install the following components on all the nodes in the cluster
kuberadm
 ```yaml
sudo apt update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
###sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-get install -y kubelet=1.25.0-00 kubeadm=1.25.0-00 kubectl=1.25.0-00
sudo apt-mark hold kubelet kubeadm kubectl

```
### To create a cluster, login into master node and execute the following
```
   sudo -i
   kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

```   
#  The commands informed by k8s cluster are
```yaml
   Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.3.0.4:6443 --token sjzz5i.4ndx09lhs8q4gct3 \
        --discovery-token-ca-cert-hash sha256:b90ea50b9c4806f1be0ba0197bc2ec3b0fc02ea48e1841102ba64b4236b04a75 --cri-socket=unix:///var/run/cri-dockerd.sock
```    

## For adding flannel
```bash

   kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

```   

1. To know nodes details
     kubectl get nodes
     kubectl get no -o wide
2. To view the api-resources
     Kubectl api-resources     