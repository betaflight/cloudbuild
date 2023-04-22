# Docker Betaflight Cloud Build
[![Docker Pulls](https://img.shields.io/docker/pulls/betaflight/cloudbuild.svg)](https://hub.docker.com/r/betaflight/cloudbuild/) [![Docker Stars](https://img.shields.io/docker/stars/betaflight/cloudbuild.svg)](https://hub.docker.com/r/betaflight/cloudbuild/) [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=flat)](https://github.com/betaflight/cloudbuild/blob/master/LICENSE)

_(Markdown optimised for display in [Dockerhub](https://hub.docker.com/r/betaflight/cloudbuild).)_

Clone and edit [Betaflight](https://github.com/betaflight/betaflight) locally on your platform. This image will take it from there and turn your code into a binary which you then can flash to your flight controller with the [Betaflight Configurator](https://github.com/betaflight/betaflight-configurator).

## Usage
### Install Docker
The latest docker platform is available from [https://www.docker.com/](https://www.docker.com/products/overview#/install_the_platform). If your system does not meet the system requirements for the latest version, check out the [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

### Running a build

Tag:     the image tag relating to the release you want to build.
Release: the release or branch / commit hash that you want to build.
Target:  the target to build e.g. BETAFLIGHTF4.
Flags:   any additional "EXTRA_FLAGS" you want to pass for the build.

```
docker run betaflight/cloudbuild:{tag} /build/build.sh {release} {target} \"{flags}\"
```

examples:

```
docker run betaflight/cloudbuild:master /build/build.sh 445758f3ec351b07c1ea77e4883a7cd4804fc7ad BETAFLIGHTF4 "-D'RELEASE_NAME=4.5.0-zulu' -DCLOUD_BUILD -DUSE_DSHOT -DUSE_GPS -DUSE_GPS_PLUS_CODES -DUSE_PINIO -DUSE_PPM -DUSE_RX_PPM -DUSE_RX_PWM -DUSE_SERIALRX -DUSE_SERIALRX_CRSF -DUSE_SERIALRX_SBUS -DUSE_TELEMETRY -DUSE_TELEMETRY_CRSF"
```

```
docker run betaflight/cloudbuild:master /build/build.sh master BETAFLIGHTF4
```

If you want the `build.sh` script to move any produced hex files to a specific location, you can do so by adding a mount to the container.

example (replace {TEMP} with your local directory):

```
docker run -v {TEMP}:/output betaflight/cloudbuild:master /build/build.sh master BETAFLIGHTF4
```

