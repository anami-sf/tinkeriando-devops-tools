                                                                                                                                                    18,38         All
#!/bin/bash

echo "-------------------------------------------------------------------------"
echo "Install the operator on your cluster"
echo "-------------------------------------------------------------------------"

sudo systemctl status containerd

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml

kubectl get pods -A

echo "-------------------------------------------------------------------------"
echo "Download the Calico networking manifest for the Kubernetes API datastore"
echo "-------------------------------------------------------------------------"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml -O

echo "-------------------------------------------------------------------------"
echo "Create the manifest to install Calico"
echo "-------------------------------------------------------------------------"
kubectl create -f custom-resources.yaml

echo "-------------------------------------------------------------------------"
echo "Confirm that calico is working"
echo "-------------------------------------------------------------------------"

watch kubectl get pods -n calico-system

echo "-------------------------------------------------------------------------"
echo "IMPORTANT: Make sure the location of "calicoctl" is on your PATH"
echo "\n"
echo "Confirm that calicoctl is installed"
echo "-------------------------------------------------------------------------"

calicoctl version

ln -s $(ls /usr/lib64/libpcap.so.1.9.* | tail -n 1) /usr/lib64/libpcap.so.0.8
ln -s $(ls /usr/lib/aarch64-linux-gnu/libpcap.so.0.8 | tail -n 1) /usr/lib64/libpcap.so.0.8

ln -s /usr/lib/aarch64-linux-gnu/libpcap.so.0.8 /usr/lib64/libpcap.so.0.8
dpkg -L libpcap0.8
ldd /usr/lib64/libpcap.so.0.8
