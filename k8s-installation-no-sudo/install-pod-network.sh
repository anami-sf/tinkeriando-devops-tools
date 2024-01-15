"install-pod-network.sh" 37L, 1707B                                                                                                                                                       18,38         All
#!/bin/bash

echo "-------------------------------------------------------------------------"
echo "Navigate to location already on PATH /usr/local/bin/"
echo "-------------------------------------------------------------------------"
cd /usr/local/bin/
pwd

echo "-------------------------------------------------------------------------"
echo "Download the Calico networking manifest for the Kubernetes API datastore"
echo "-------------------------------------------------------------------------"
# https://docs.tigera.io/calico/latest/operations/calicoctl/install#install-calicoctl-as-a-binary-on-a-single-host
curl -L https://github.com/projectcalico/calico/releases/download/v3.27.0/calicoctl-linux-arm64 -o calicoctl

echo "-------------------------------------------------------------------------"
echo "Set the file to be executable"
echo "-------------------------------------------------------------------------"
chmod +x /usr/local/bin/calicoctl

echo "-------------------------------------------------------------------------"
echo "Apply the manifest"
echo "-------------------------------------------------------------------------"
kubectl apply -f calico.yaml

echo "-------------------------------------------------------------------------"
echo "Confirm that calico is working"
echo "-------------------------------------------------------------------------"

kubectl get pods -A

echo "-------------------------------------------------------------------------"
echo "IMPORTANT: Make sure the location of "calicoctl" is on your PATH"
echo "\n"
echo "Confirm that calicoctl is installed"
echo "-------------------------------------------------------------------------"

calicoctl version

nami@pi4-2gb-node1:/usr/local/bin$ sudo kubectl apply -f calico.yaml
error: error validating "calico.yaml": error validating data: failed to download openapi: Get "https://10.0.0.216:6443/openapi/v2?timeout=32s": 
dial tcp 10.0.0.216:6443: connect: connection refused; if you choose to ignore these errors, turn validation off with --validate=false