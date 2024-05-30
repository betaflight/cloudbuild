
Parameters for the `build-image.sh` shell script:

1. ARM base image to be utilised (named after the ARM version).
2. Branch to be used as the base (other branchs can be checked out within the image).
3. Tag to be applied (defaults to branch if not supplied).
4. Repository to use (defaults to https://github.com/betaflight/betaflight if not supplied).

Building the master image:

```./build-image.sh 10.3 master```

Building the release images:

```./build-image.sh 10.3 4.5-maintenance 4.5.X```
```./build-image.sh 10.3 4.4-maintenance 4.4.X```

Building the KAACK image:

```./build-image.sh 10.3 KAACK-4.5.0 KAACK https://github.com/limonspb/betaflight```

