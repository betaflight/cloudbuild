#!/bin/bash

BASE=$1
BRANCH=$2
TAG=$3
REPO=$4

if [ -z "$BASE" ]; then
    BASE="10.3"
fi

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

docker build ./ -f Dockerfile --tag "betaflight/cloudbuild:${TAG}" --build-arg NOCACHE=$(date +%s) --build-arg COMMIT=${BRANCH} --build-arg REPO=${REPO} --build-arg BASE=${BASE}
