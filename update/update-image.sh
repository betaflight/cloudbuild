#!/bin/bash

TAG=$1

if [ -z "$TAG" ]; then
    TAG="master"
fi

echo "using ${TAG}"

docker build ./ -f Dockerfile --tag "betaflight/cloudbuild:${TAG}" --build-arg NOCACHE=$(date +%s) --build-arg TAG=${TAG}
