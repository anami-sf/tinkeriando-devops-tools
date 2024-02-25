#!/bin/bash

set -x

ip route show # Look for a line starting with "default via"

echo "-------------------------------------------------------------------------" 
echo "Initialize control-plane"
echo "-------------------------------------------------------------------------" 
# Considerations about apiserver-advertise-address and ControlPlaneEndpoint
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#considerations-about-apiserver-advertise-address-and-controlplaneendpoint
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.0.0.213

echo "-------------------------------------------------------------------------" 
echo 'From k8 control-plane node follow instructions in "join-pods-token"'
echo "-------------------------------------------------------------------------"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config