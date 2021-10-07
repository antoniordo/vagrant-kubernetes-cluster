#!/usr/bin/env bash
set -e

sudo swapoff -a
sudo kubeadm config images pull

# init kubernetes cluster
echo "kubeadm token = ${K8S_TOKEN}"
sudo kubeadm init --token "${K8S_TOKEN}" --apiserver-advertise-address "${MACHINE_IP}" --apiserver-cert-extra-sans="${MACHINE_IP}"  "${KUBE_INIT_EXTRA_ARGS}"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sleep 5

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml