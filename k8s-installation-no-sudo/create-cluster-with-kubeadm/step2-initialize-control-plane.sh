#!/bin/bash

set -x

HOST="10.0.0.16"

echo "-------------------------------------------------------------------------" 
echo "Initialize control-plane"
echo "-------------------------------------------------------------------------" 
# Considerations about apiserver-advertise-address and ControlPlaneEndpoint
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#considerations-about-apiserver-advertise-address-and-controlplaneendpoint

# IMPORTANT: Choose the appropriate network CIDR below 

# For FLANNEL !!
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$HOST

# For CALICO !!
# sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$HOST

echo "-------------------------------------------------------------------------" 
echo 'From k8 control-plane node follow instructions in "join-pods-token"'
echo "-------------------------------------------------------------------------"

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
