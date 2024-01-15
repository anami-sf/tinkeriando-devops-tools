#!/bin/bash

# Install kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

echo "-------------------------------------------------------------------------"
echo "Starting K8's install with kubeadm "
echo "-------------------------------------------------------------------------" 

echo "STEPS"
echo "1. Install a container runtime - containerd"
echo "2. Install kubelet, kubeadm, and kubectl"
echo "\n"
echo "VERSIONS"
echo "Kubernetes: 1.29"
echo "\n"
echo "-------------------------------------------------------------------------"

# TODO: do a check with conditional
# Check if required ports are open
# nc 127.0.0.1 6443

echo "-------------------------------------------------------------------------" 
echo "Disable swap spaces "
echo "-------------------------------------------------------------------------" 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
# Disables swap temporarily only
sudo swapoff -a
# To disable wap permanently, configuration files need to be modified as well
# TODO: disable swap in systemd.swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "-------------------------------------------------------------------------"
echo "Install and configure prerequisites"
echo "-------------------------------------------------------------------------"
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#install-and-configure-prerequisites
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

echo "-------------------------------------------------------------------------"
echo "Verify that the br_netfilter, overlay modules are loaded"
echo "-------------------------------------------------------------------------"
# TODO: Add conditional for check
sudo modprobe overlay
sudo modprobe br_netfilter

echo "-------------------------------------------------------------------------"
echo "sysctl params required by setup, params persist across reboots"
echo "-------------------------------------------------------------------------"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

echo "-------------------------------------------------------------------------"
echo "Apply sysctl params without reboot"
echo "-------------------------------------------------------------------------"
sudo sysctl --system


echo "-------------------------------------------------------------------------"
echo "Verify that the br_netfilter, overlay modules are loaded by running"
echo "-------------------------------------------------------------------------"
# TODO: Add conditional for check
lsmod | grep br_netfilter
lsmod | grep overlay

echo "-------------------------------------------------------------------------"
echo "Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config"
echo "-------------------------------------------------------------------------"
# TODO: Add conditional for check
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

echo "-------------------------------------------------------------------------"
echo "Installing container runtime -- containerd -- with package manager apt-get"
echo "-------------------------------------------------------------------------"
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md#option-2-from-apt-get-or-dnf
# https://docs.docker.com/engine/install/ubuntu/

echo "-------------------------------------------------------------------------"
echo "Uninstall possible conflicting packages"
echo "-------------------------------------------------------------------------"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
    do sudo apt-get remove $pkg; 
done

echo "-------------------------------------------------------------------------"
echo "Install containerd from Docker repository from apt repository"
echo "Setup the repository"
echo "-------------------------------------------------------------------------"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

echo "-------------------------------------------------------------------------"
echo "Add Docker's official GPG key"
echo "-------------------------------------------------------------------------"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "-------------------------------------------------------------------------"
echo "Add the repository to Apt sources"
echo "-------------------------------------------------------------------------"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "-------------------------------------------------------------------------"
echo "Install containerd"
echo "-------------------------------------------------------------------------" 
# There is no need to intall any other additional docker tools such as the cli or compose
sudo apt-get install containerd.io

echo "-------------------------------------------------------------------------" 
echo "Verify that containerd is running"
echo "-------------------------------------------------------------------------" 
# TODO: Add conditional
systemctl status containerd

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
sudo cp containerd-config.toml /etc/containerd/config.toml
sudo systemctl restart containerd 

echo "-------------------------------------------------------------------------" 
echo "Install kubeadm, kubelet and kubectl"
echo "-------------------------------------------------------------------------"      
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

sudo apt-get update

echo "-------------------------------------------------------------------------" 
echo "Install packages needed to use the Kubernetes apt repository"
# apt-transport-https may be a dummy package; if so, you can skip that package
echo "-------------------------------------------------------------------------" 
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

echo "-------------------------------------------------------------------------" 
echo "Download the public signing key for the Kubernetes package repositories "
echo "-------------------------------------------------------------------------" 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "-------------------------------------------------------------------------" 
echo "Add Kubernetes repositories for ** Kubernetes 1.29 ** (not included in the default Ubuntu repositories)"
echo "-------------------------------------------------------------------------" 
# Warning: this repository has packages only for Kubernetes 1.29, 
# for other Kubernetes minor versions, you need to change the Kubernetes minor version in the URL.
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "-------------------------------------------------------------------------" 
echo "Install kubelet, kubeadm, and kubectl"
echo "-------------------------------------------------------------------------" 
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

echo "-------------------------------------------------------------------------" 
echo "Mark the packages as held back to prevent automatic installation, upgrade, or removal"
echo "-------------------------------------------------------------------------" 
sudo apt-mark hold kubelet kubeadm kubectl


echo "-------------------------------------------------------------------------" 
echo "Verify kubeadm installation"
echo "-------------------------------------------------------------------------" 
# TODO: do a check with conditional
kubeadm version
