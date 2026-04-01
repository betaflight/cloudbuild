#!/bin/bash

BRANCH=$1
TAG=$2
REPO=$3

if [ -z "$BRANCH" ]; then
    BRANCH="master"
fi

if [ -z "$TAG" ]; then
    TAG=${BRANCH}
fi

if [ -z "$REPO" ]; then
    REPO="https://github.com/betaflight/betaflight.git"
fi

echo "Building base image: betaflight/cloudbuild"
docker build ./ -f Dockerfile --tag "betaflight/cloudbuild:base"

echo ""
echo "Building image: betaflight/cloudbuild:${TAG} -> ${BRANCH} (${REPO})"
docker build ./ -f Dockerfile-build --tag "betaflight/cloudbuild:${TAG}" \
    --build-arg NOCACHE=$(date +%s) \
    --build-arg COMMIT=${BRANCH} \
    --build-arg REPO=${REPO}
