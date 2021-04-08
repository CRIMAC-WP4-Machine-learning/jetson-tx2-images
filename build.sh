#!/bin/bash

# Create temporary log directory
mkdir -p $OUT_DIR

# Create and push the base image first as the requirements for the following images
docker build -f Dockerfile.crimac-tx2-base -t docker.io/crimac/jetson-tx2-base . > ${OUT_DIR}/build_base.log 2>&1
docker push docker.io/crimac/jetson-tx2-base > ${OUT_DIR}/push_base.log 2>&1

# Create and pus both preprocessing and pytorch images
docker build -f Dockerfile.crimac-tx2-preprocess -t docker.io/crimac/jetson-tx2-preprocess . > ${OUT_DIR}/build_preprocessor.log 2>&1
docker push docker.io/crimac/jetson-tx2-preprocess > ${OUT_DIR}/push_preprocessor.log 2>&1

docker build -f Dockerfile.crimac-tx2-pytorch -t docker.io/crimac/jetson-tx2-pytorch . > ${OUT_DIR}/build_pytorch.log 2>&1
docker push docker.io/crimac/jetson-tx2-pytorch > ${OUT_DIR}/push_pytorch.log 2>&1


# Collate logs
tar czvf logs.tgz ${OUT_DIR}
