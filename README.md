# Betaflight Build
[![Docker Pulls](https://img.shields.io/docker/pulls/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![Docker Stars](https://img.shields.io/docker/stars/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=flat)](https://github.com/betaflight/betaflight-build/blob/master/LICENSE)

_(Markdown optimised for display in [Docker Hub](https://hub.docker.com/r/betaflight/betaflight-build).)_

Docker images containing the toolchains needed to build [Betaflight](https://github.com/betaflight/betaflight) firmware, one image per platform SDK. Mount your own Betaflight checkout and run `make` as you would locally, with no toolchain installation required.

The toolchains are installed by Betaflight's own build system (`make SDK=<sdk> platform-tools-install`), so each image matches exactly what the Betaflight version it was built from expects.

## Tags

`betaflight/betaflight-build:<sdk>-<version>`

| SDK | Platforms |
| --- | --- |
| `arm` | STM32F4/F7/G4/H7, AT32 and other ARM targets without a vendor SDK |
| `stm32h5`, `stm32c5`, `stm32n6` | STM32H5, STM32C5, STM32N6 |
| `apm32f4` | APM32F4 |
| `x32m7` | X32M7 |
| `pico_sdk` | RP2350 (PICO) |
| `esp_idf` | ESP32 |

`<version>` is the Betaflight branch the image was built from, e.g. `master`, `2026.6`, `2025.12`, `4.5`. The bare `<sdk>` tag (e.g. `arm`) tracks `master`.

Releases before 2025.12 (4.4, 4.5) only have the `arm` image.

Images are published for `linux/amd64` and `linux/arm64`.

## Usage

From the root of a Betaflight checkout:

```
docker run --rm -u $(id -u):$(id -g) -v "$PWD":/src betaflight/betaflight-build:arm make STM32F405
```

Build artifacts (`.hex`, `.uf2`, `.bin`) are written to `obj/` in your checkout. Running as your own user (`-u`) keeps them owned by you.

Configuration based targets work the same way:

```
docker run --rm -u $(id -u):$(id -g) -v "$PWD":/src betaflight/betaflight-build:arm sh -c "make configs && make CONFIG=MATEKF405AIO"
```

Platform SDK submodules are hydrated automatically by the Betaflight build system on first use.

To find which SDK a target needs:

```
make BUILD=RP2350B build-sdk-print
```

Unit tests (`make test`) can be run in any of the images.

## Building the images

Build images for every SDK of a Betaflight branch:

```
./build-image.sh -r 2025.12-maintenance
```

Build specific SDKs:

```
./build-image.sh arm pico_sdk
```

Build from a fork:

```
./build-image.sh -R https://github.com/user/betaflight.git -r my-branch arm
```

`-p` builds for `linux/amd64` and `linux/arm64` and pushes to the registry. Set `IMAGE` to publish under a different name.

Images are published to Docker Hub by the [Publish](https://github.com/betaflight/betaflight-build/actions/workflows/publish.yml) workflow on every push to `master`, weekly, and on demand for any Betaflight branch.
