#!/bin/bash

echo "-------------------------------------------------------------------------" 
echo "IMPORTANT: It's critical that the kubelet and the container runtime use the same cgroup driver 
and are configured the same.

- If we are using a systemd init system, then we have to use systemd c-group driver

- https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers
comment"

echo "Check which init system we are using"
echo "-------------------------------------------------------------------------" 
ps -p 1

echo "-------------------------------------------------------------------------" 
echo "Configure c-group driver "
echo "-------------------------------------------------------------------------" 
cp containerd-config.toml /etc/containerd/config.toml
systemctl restart containerd 

echo "-------------------------------------------------------------------------" 
echo "Install kubeadm, kubelet and kubectl"
echo "-------------------------------------------------------------------------"      
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

apt-get update

echo "-------------------------------------------------------------------------" 
echo "Install packages needed to use the Kubernetes apt repository"
# apt-transport-https may be a dummy package; if so, you can skip that package
echo "-------------------------------------------------------------------------" 
apt-get install -y apt-transport-https ca-certificates curl gpg

echo "-------------------------------------------------------------------------" 
echo "Download the public signing key for the Kubernetes package repositories "
echo "-------------------------------------------------------------------------" 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "-------------------------------------------------------------------------" 
echo "Add Kubernetes repositories for ** Kubernetes 1.29 ** (not included in the default Ubuntu repositories)"
echo "-------------------------------------------------------------------------" 
# Warning: this repository has packages only for Kubernetes 1.29, 
# for other Kubernetes minor versions, you need to change the Kubernetes minor version in the URL.
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

echo "-------------------------------------------------------------------------" 
echo "Install kubelet, kubeadm, and kubectl"
echo "-------------------------------------------------------------------------" 
apt-get update
apt-get install -y kubelet kubeadm kubectl

echo "-------------------------------------------------------------------------" 
echo "Mark the packages as held back to prevent automatic installation, upgrade, or removal"
echo "-------------------------------------------------------------------------" 
apt-mark hold kubelet kubeadm kubectl

echo "-------------------------------------------------------------------------" 
echo "Verify kubeadm installation"
echo "-------------------------------------------------------------------------" 
# TODO: do a check with conditional
kubeadm version
