#!/bin/bash

# Create and push the base image first as the requirements for the following images
docker build -f Dockerfile.crimac-tx2-base -t docker.io/crimac/jetson-tx2-base .
docker push docker.io/crimac/jetson-tx2-base

# Create and pus both preprocessing and pytorch images
docker build -f Dockerfile.crimac-tx2-preprocess -t docker.io/crimac/jetson-tx2-preprocess .
docker push docker.io/crimac/jetson-tx2-preprocess

docker build -f Dockerfile.crimac-tx2-pytorch -t docker.io/crimac/jetson-tx2-pytorch .
docker push docker.io/crimac/jetson-tx2-pytorch