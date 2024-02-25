                                                                                                                                                    18,38         All
#!/bin/bash

echo "-------------------------------------------------------------------------"
echo "Install the operator on your cluster"
echo "-------------------------------------------------------------------------"

sudo systemctl status containerd

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml

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

anami@pi4-2gb-node1:/usr/local/bin$ sudo kubectl apply -f calico.yaml
error: error validating "calico.yaml": error validating data: failed to download openapi: Get "https://10.0.0.216:6443/openapi/v2?timeout=32s": 
dial tcp 10.0.0.216:6443: connect: connection refused; if you choose to ignore these errors, turn validation off with --validate=false