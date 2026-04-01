#!/bin/bash

COMMIT=$1
TARGET=$2
FLAGS=$3

if [ -z "$COMMIT" ] || [ -z "$TARGET" ]; then
    echo "Usage: build.sh <commit> <target> [flags]"
    echo "  commit: git commit hash, branch, or tag to build"
    echo "  target: build target e.g. BETAFLIGHTF4"
    echo "  flags:  optional EXTRA_FLAGS for the build"
    exit 1
fi

echo ""
echo "Fetching from Github (${COMMIT}):"

cd /source
git fetch origin "${COMMIT}":CLOUD_HEAD || { echo "fetch failed with $?"; exit 1; }

echo ""
echo "Checking out CLOUD_HEAD (for ${COMMIT})"

cd /source
git checkout -f CLOUD_HEAD || { echo "checkout failed with $?"; exit 1; }

# Update submodules for the checked-out commit
git submodule update --checkout -- src/config 2>/dev/null

if [[ -d "/source/src/config" ]] ; then
    cd /source
    make configs || { echo "make configs failed with $?"; exit 1; }
fi

# Sync platform SDK submodules to match the checked-out commit
git submodule update --checkout --recursive -- lib/main/pico-sdk 2>/dev/null
git submodule update --checkout -- lib/main/STM32N6 2>/dev/null
if [[ -d "/source/lib/main/STM32N6" ]] ; then
    cd /source/lib/main/STM32N6
    git submodule update --checkout -- \
        Drivers/STM32N6xx_HAL_Driver \
        Drivers/CMSIS/Device/ST/STM32N6xx 2>/dev/null
    cd /source
fi

echo ""
echo "Commencing the build (make ${TARGET}):"

cd /source
make $TARGET EXTRA_FLAGS="${FLAGS}" || { echo "make failed with $?"; exit 1; }

echo ""

if [[ -d "/output" ]] ; then
    echo "Copying build artifacts (to output):"
    cp -v /source/obj/*.hex /output 2>/dev/null
    cp -v /source/obj/*.uf2 /output 2>/dev/null
    echo " -> completed"
else
    echo "Skipping copying build artifacts (no output mount for container)"
fi
