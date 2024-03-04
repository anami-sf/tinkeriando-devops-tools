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
swapoff -a
# To disable wap permanently, configuration files need to be modified as well
# TODO: disable swap in systemd.swap
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "-------------------------------------------------------------------------"
echo "Install and configure prerequisites"
echo "-------------------------------------------------------------------------"
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#install-and-configure-prerequisites
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

echo "-------------------------------------------------------------------------"
echo "Verify that the br_netfilter, overlay modules are loaded"
echo "-------------------------------------------------------------------------"
# TODO: Add conditional for check
modprobe overlay
modprobe br_netfilter

echo "-------------------------------------------------------------------------"
echo "sysctl params required by setup, params persist across reboots"
echo "-------------------------------------------------------------------------"
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

echo "-------------------------------------------------------------------------"
echo "Apply sysctl params without reboot"
echo "-------------------------------------------------------------------------"
sysctl --system


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
    do apt-get remove $pkg; 
done

echo "-------------------------------------------------------------------------"
echo "Install cri-o"
echo "-------------------------------------------------------------------------"

# https://kubernetes.io/blog/2023/10/10/cri-o-community-package-infrastructure/#deb-based-distributions

apt-get update
apt-get install -y software-properties-common curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update
apt-get install -y cri-o kubelet kubeadm kubectl

echo 'cgroup_enable=memory cgroup_memory=1' >> /boot/firmware/cmdline.txt

systemctl start crio.service
