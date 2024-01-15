#!/bin/bash

echo "-------------------------------------------------------------------------" 
echo "Download the Calico networking manifest for the Kubernetes API datastore"
echo "-------------------------------------------------------------------------" 
# https://docs.tigera.io/calico/latest/operations/calicoctl/install#install-calicoctl-as-a-binary-on-a-single-host  
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml -O

echo "-------------------------------------------------------------------------" 
echo "Apply the manifest"
echo "-------------------------------------------------------------------------" 
kubectl apply -f calico.yaml

echo "-------------------------------------------------------------------------" 
echo "Navigate to location already on PATH /usr/local/bin/"
echo "-------------------------------------------------------------------------" 
cd /usr/local/bin/

echo "-------------------------------------------------------------------------" 
Set the file to be executable
echo "-------------------------------------------------------------------------" 
chmod +x calicoctl

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
