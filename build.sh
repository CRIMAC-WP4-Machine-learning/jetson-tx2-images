#!/bin/bash

# Create temporary log directory
mkdir -p $OUT_DIR

# Create and push the base image first as the requirements for the following images
docker build -f Dockerfile.crimac-tx2-base -t docker.io/crimac/jetson-tx2-base . > ${OUT_DIR}/build_base.log 2>&1
docker push docker.io/crimac/jetson-tx2-base > ${OUT_DIR}/push_base.log 2>&1

# Create and push preprocessing images
docker build -f Dockerfile.crimac-tx2-preprocess -t docker.io/crimac/jetson-tx2-preprocess . > ${OUT_DIR}/build_preprocessor.log 2>&1
docker push docker.io/crimac/jetson-tx2-preprocess > ${OUT_DIR}/push_preprocessor.log 2>&1


# Create Pytorch wheel and copy to $OUT_DIR on the host
DOCKER_BUILDKIT=1 docker build --progress plain --target export --file Dockerfile.crimac-tx2-pytorch --output out . > ${OUT_DIR}/build_pytorch_export.log 2>&1
DOCKER_BUILDKIT=1 docker build --progress plain --target final -f Dockerfile.crimac-tx2-pytorch -t docker.io/crimac/jetson-tx2-pytorch . > ${OUT_DIR}/build_pytorch_final.log 2>&1
docker push docker.io/crimac/jetson-tx2-pytorch > ${OUT_DIR}/push_pytorch.log 2>&1

# Collate artifacts
tar czvf ${ARTIFACTS} ${OUT_DIR}

# Upload to S3
aws s3 cp ${ARTIFACTS} s3://${BUCKET_NAME}/tmp/build_logs.tgz
WHEEL=$(find out -name "*.whl")
aws s3 cp ${WHEEL} s3://${BUCKET_NAME}/tmp/$(basename ${WHEEL})
