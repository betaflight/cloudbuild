#!/bin/bash

set -euo pipefail

IMAGE="${IMAGE:-betaflight/betaflight-build}"
REF="master"
REPO="https://github.com/betaflight/betaflight.git"
PUSH=0
PLATFORMS="linux/amd64,linux/arm64"

usage() {
    echo "Usage: build-image.sh [-r ref] [-R repo] [-p] [sdk...]"
    echo "  -r ref:  betaflight branch, tag or commit (default: ${REF})"
    echo "  -R repo: betaflight git repository (default: ${REPO})"
    echo "  -p:      build for ${PLATFORMS} and push to the registry"
    echo "  sdk:     SDK(s) to build an image for (default: all SDKs for the ref)"
    echo "Set IMAGE to change the image name (default: ${IMAGE})"
    exit 1
}

while getopts "r:R:ph" opt; do
    case "${opt}" in
        r) REF="${OPTARG}" ;;
        R) REPO="${OPTARG}" ;;
        p) PUSH=1 ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

SDKS=("$@")

COMMIT=$(git ls-remote "${REPO}" "refs/heads/${REF}" "refs/tags/${REF}" | head -n 1 | cut -f 1)
COMMIT="${COMMIT:-${REF}}"

if [ ${#SDKS[@]} -eq 0 ]; then
    IIDFILE=$(mktemp)
    trap 'rm -f "${IIDFILE}"' EXIT
    docker buildx build . --load --quiet --target source --iidfile "${IIDFILE}" \
        --build-arg BETAFLIGHT_REPO="${REPO}" \
        --build-arg BETAFLIGHT_REF="${COMMIT}" > /dev/null
    read -r -a SDKS <<< "$(docker run --rm "$(cat "${IIDFILE}")" make -s platform-sdk-list-print 2>/dev/null || echo arm)"
    docker rmi "$(cat "${IIDFILE}")" > /dev/null
fi

VERSION="${REF%-maintenance}"
VERSION="${VERSION//\//-}"

if [ ${PUSH} -eq 1 ]; then
    OUTPUT=(--platform "${PLATFORMS}" --push)
else
    OUTPUT=(--load)
fi

for SDK in "${SDKS[@]}"; do
    TAGS=(--tag "${IMAGE}:${SDK}-${VERSION}")
    if [ "${REF}" = "master" ]; then
        TAGS+=(--tag "${IMAGE}:${SDK}")
    fi

    echo "Building ${IMAGE}:${SDK}-${VERSION} (${REPO} @ ${REF} ${COMMIT})"
    docker buildx build . "${OUTPUT[@]}" "${TAGS[@]}" \
        --build-arg BETAFLIGHT_REPO="${REPO}" \
        --build-arg BETAFLIGHT_REF="${COMMIT}" \
        --build-arg SDK="${SDK}"
done
