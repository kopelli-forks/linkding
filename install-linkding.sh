#!/usr/bin/env bash

# Script for creating or updating a linkding installation / Docker container
# The script uses a number of variables that control how the container is set up
# and where the application data is stored on the host
# The following variables are available:
#
# LD_CONTAINER_NAME - name of the Docker container that should be created or updated
# LD_HOST_PORT - port on your system that the application will use
# LD_HOST_DATA_DIR - directory on your system where the applications database will be stored
#
# Variables can be from your shell like this:
# export LD_HOST_DATA_DIR=/etc/linkding/data

# Provide default variable values
if [ -z "${LD_CONTAINER_NAME}" ]; then
    LD_CONTAINER_NAME="linkding"
fi
if [ -z "${LD_HOST_PORT}" ]; then
    LD_HOST_PORT=8080
fi
if [ -z "${LD_HOST_DATA_DIR}" ]; then
    LD_HOST_DATA_DIR="${XDG_DATA_HOME}/linkding/data"
fi
if [ -z "${LD_DOCKER_IMAGE}" ]; then
  LD_DOCKER_IMAGE="sissbrueker/linkding"
fi
if [ -z "${LD_DOCKER_IMAGE_VERSION}" ]; then
  LD_DOCKER_IMAGE_VERSION="latest"
fi

DOCKER_IMAGE_TAG="${LD_DOCKER_IMAGE}:${LD_DOCKER_IMAGE_VERSION}"

echo "Create or update linkding container"
echo "Container name: ${LD_CONTAINER_NAME}"
echo "Docker image: ${DOCKER_IMAGE_TAG}"
echo "Host port: ${LD_HOST_PORT}"
echo "Host data dir: ${LD_HOST_DATA_DIR}"

echo "Stop existing container..."
docker stop ${LD_CONTAINER_NAME} || true
echo "Remove existing container..."
docker rm ${LD_CONTAINER_NAME} || true
echo "Update image..."
docker pull "${DOCKER_IMAGE_TAG}"
echo "Start container..."
docker run -d \
  -p ${LD_HOST_PORT}:9090 \
  --name ${LD_CONTAINER_NAME} \
  -v "${LD_HOST_DATA_DIR}":/etc/linkding/data \
  "${DOCKER_IMAGE_TAG}"
echo "Done!"
