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

echo "using ${TAG} -> ${BRANCH} (${REPO})"

docker build ./build -f build/Dockerfile --tag "betaflight/cloudbuild:${TAG}" --build-arg NOCACHE=$(date +%s) --build-arg COMMIT=${BRANCH} --build-arg REPO=${REPO}
