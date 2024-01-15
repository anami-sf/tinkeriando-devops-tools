#!/bin/bash

ip route show # Look for a line starting with "default via"

echo "-------------------------------------------------------------------------" 
echo "Initialize control-plane"
echo "-------------------------------------------------------------------------" 
# Considerations about apiserver-advertise-address and ControlPlaneEndpoint
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#considerations-about-apiserver-advertise-address-and-controlplaneendpoint
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.0.0.216 &> join-pods-token

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
