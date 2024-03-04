#!/bin/bash

echo '-------------------------------------------------------------------------' 
echo "Once all the worker nodes have been added to the cluster, test out the k8's set up"
echo 'Look for a newly created pod labeled "test-nginx"'
echo "-------------------------------------------------------------------------" 

kubectl run test-nginx --image=nginx
kubectl get pod --watch