#!/bin/bash

# =================================================
# Frontend
# =================================================

# Move into folder containing Dockerfile
cd app

# Build app for production - creates dist folder
yarn build

# Build and push prod docker image
docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v7 -t anami127001/tinkeriando-ui:latest -f Dockerfile.prod --push .

# Push Docker image to DockerHub
docker push anami127001/tinkeriando-ui:latest

# =================================================
# KUBERNETES configurations
# =================================================

# Move into correct folder
cd ui

# Create namespace
kubectl create namespace tinkeriando

# Set the tinkeriando namespace as the default context:
kubectl config set-context --current --namespace=tinkeriando

# Create deployment
kubectl apply -f ui-deployment.yml

# Create service
    # kubectl get services -o=wide
    # kubectl get pods --selector=app=tinkeriando-ui
    # kubectl get endpoints tinkeriando-ui-service

kubectl apply -f ui-service.yml
