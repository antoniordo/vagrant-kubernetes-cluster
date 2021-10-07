#!/usr/bin/env bash
set -e

# Basic packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common jq lsb-release

# Configure repositories

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Kubernetes
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Instalations
sudo apt-get update
sudo apt-get install -y \
  docker-ce docker-ce-cli \
  containerd.io \
  kubelet kubeadm \
  kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Configure Docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
DOCKER_USER="${USER}"
sudo usermod -aG docker "${DOCKER_USER}"
sudo systemctl enable docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker.service

# Configure Kubernetes tools
echo "KUBELET_EXTRA_ARGS=--node-ip=${MACHINE_IP}" | sudo tee /etc/default/kubelet

