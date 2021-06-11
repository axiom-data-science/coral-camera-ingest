#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/.env"

DOCKER_PATH=`which docker`
DOCKERCOMPOSE_PATH=`which docker-compose`

 # Create media server volume, build image, and run docker-compose
$DOCKER_PATH volume create amsdata \
    && $DOCKER_PATH build -t "$IMAGE_AMS" "$DIR" \
    && $DOCKERCOMPOSE_PATH up
