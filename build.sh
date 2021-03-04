#!/usr/bin/bash

# Make the base image first as the requirements for the following images
docker build -f Dockerfile.crimac-tx2-base -t crimac-tx2-base .

# Create both pytorch and preprocessing images
docker build -f Dockerfile.crimac-tx2-pytorch -t crimac-tx2-pytorch .
docker build -f Dockerfile.crimac-tx2-preprocess -t crimac-tx2-preprocess .

# TODO: Push images to docker hub
