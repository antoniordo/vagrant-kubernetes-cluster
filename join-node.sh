#!/usr/bin/env bash
set -e

sudo kubeadm join "${MASTER_IP}":6443 --token "${K8S_TOKEN}" --discovery-token-unsafe-skip-ca-verification