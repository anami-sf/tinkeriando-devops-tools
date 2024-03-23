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
