#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/.env"

 # Create media server volume, build image, and run docker-compose
docker volume create amsdata \
    && docker build -t "$IMAGE_AMS" "$DIR" \
    && docker-compose up
