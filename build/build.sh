#!/bin/bash

COMMIT=$1
TARGET=$2
FLAGS=$3

echo ""
echo "Pulling from Github (${COMMIT}):"

cd /source
git fetch origin "${COMMIT}":CLOUD_HEAD || { echo "fetch failed with $?"; exit 1; }
[ $? == 1 ] && exit 0;

echo ""
echo "Checking out the branch -> CLOUD_HEAD (for ${COMMIT})"

cd /source
git checkout -f CLOUD_HEAD || { echo "checkout failed with $?"; exit 1; }
[ $? == 1 ] && exit 0;

echo ""
echo "Commencing the build (make ${TARGET}):"

cd /source
make $TARGET EXTRA_FLAGS="${FLAGS}" || { echo "make failed with $?"; exit 1; }
[ $? == 1 ] && exit 0;

echo ""

if [[ -d "/output" ]] ; then
    echo "Copying hex files (to output):"
    cp -v /source/obj/*.hex /output
    echo " -> completed"
else
    echo "Skipping copying hex files (no output mount for container)"
fi
