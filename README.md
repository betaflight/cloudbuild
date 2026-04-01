# Docker Betaflight Cloud Build
[![Docker Pulls](https://img.shields.io/docker/pulls/betaflight/cloudbuild.svg)](https://hub.docker.com/r/betaflight/cloudbuild/) [![Docker Stars](https://img.shields.io/docker/stars/betaflight/cloudbuild.svg)](https://hub.docker.com/r/betaflight/cloudbuild/) [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=flat)](https://github.com/betaflight/cloudbuild/blob/master/LICENSE)

_(Markdown optimised for display in [Dockerhub](https://hub.docker.com/r/betaflight/cloudbuild).)_

A Docker base image for building [Betaflight](https://github.com/betaflight/betaflight) firmware. Supports all target platforms including STM32 (F4/F7/G4/H5/H7/N6) and PICO (RP2350).

## Toolchain

The base image (`betaflight/cloudbuild:base`) includes:

- **ARM GNU Toolchain 13.3.Rel1** - cross-compiler for all ARM targets
- **clang-18** - blocks runtime support
- **cmake / gcc / g++** - required for building platform tools (e.g. picotool)
- **python3-intelhex** - hex/dfu conversion

SDK submodules (PICO SDK, STM32CubeN6) are hydrated automatically by the Betaflight build system when needed.

## Usage

### Install Docker
The latest docker platform is available from [https://www.docker.com/](https://www.docker.com/products/overview#/install_the_platform).

### Building the images

Build the base image and a tagged build image:

```
./build-image.sh master
```

Build a specific branch with a custom tag:

```
./build-image.sh 4.6-maintenance 4.6.X
```

Build from a fork:

```
./build-image.sh master custom-tag https://github.com/user/betaflight.git
```

### Running a build

`{tag}`:     the image tag relating to the release you want to build.

`{release}`: the release or branch / commit hash that you want to build.

`{target}`:  the target to build e.g. BETAFLIGHTF4.

`{flags}`:   any additional "EXTRA_FLAGS" you want to pass for the build.


```
docker run betaflight/cloudbuild:{tag} /build/build.sh {release} {target} "{flags}"
```

examples:

```
docker run betaflight/cloudbuild:master /build/build.sh master BETAFLIGHTF4
```

```
docker run betaflight/cloudbuild:master /build/build.sh 445758f3ec351b07c1ea77e4883a7cd4804fc7ad BETAFLIGHTF4 "-D'RELEASE_NAME=4.6.0' -DCLOUD_BUILD"
```

To copy produced build artifacts to a local directory, add a volume mount:

```
docker run -v /tmp/output:/output betaflight/cloudbuild:master /build/build.sh master BETAFLIGHTF4
```

Build artifacts (`.hex`, `.uf2`) will be copied to the mounted directory.
