# Betaflight Cloud Build - Base Image
#
# Provides all toolchains and dependencies required to build any
# Betaflight target (STM32F4/F7/G4/H5/H7/N6, PICO RP2350).
#
# ARM GNU Toolchain 10.3-2021.10  (4.4.x, 4.5.x)
# ARM GNU Toolchain 13.3.Rel1    (2025.12.x+)
#

FROM docker.io/library/debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install base build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    make \
    cmake \
    curl \
    xz-utils \
    xxd \
    gcc \
    g++ \
    python3-intelhex \
    libblocksruntime-dev \
    && rm -rf /var/lib/apt/lists/*

# Install clang-18 (required for blocks runtime support)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    clang-18 \
    llvm-18-dev \
    libc++-18-dev \
    libc++abi-18-dev \
    libclang-rt-18-dev \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 100

# Install ARM GNU Toolchain 10.3-2021.10 (for 4.4.x and 4.5.x)
ARG TOOLS_DIR="/tools"
ARG ARM_SDK_10_DIR="${TOOLS_DIR}/gcc-arm-none-eabi-10.3-2021.10"
ARG ARM_SDK_10_FILE="gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2"
ARG ARM_SDK_10_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2"

RUN mkdir -p ${TOOLS_DIR} && \
    curl -L -k -o "/tmp/${ARM_SDK_10_FILE}" "${ARM_SDK_10_URL}" && \
    tar -C ${TOOLS_DIR} -xjf "/tmp/${ARM_SDK_10_FILE}" && \
    rm "/tmp/${ARM_SDK_10_FILE}" && \
    ${ARM_SDK_10_DIR}/bin/arm-none-eabi-gcc -dumpversion

# Install ARM GNU Toolchain 13.3.Rel1 (for 2025.12.x+)
ARG ARM_SDK_13_DIR="${TOOLS_DIR}/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi"
ARG ARM_SDK_13_FILE="arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz"
ARG ARM_SDK_13_URL="https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz"

RUN curl -L -k -o "/tmp/${ARM_SDK_13_FILE}" "${ARM_SDK_13_URL}" && \
    tar -C ${TOOLS_DIR} -xf "/tmp/${ARM_SDK_13_FILE}" && \
    rm "/tmp/${ARM_SDK_13_FILE}" && \
    ${ARM_SDK_13_DIR}/bin/arm-none-eabi-gcc -dumpversion

ENV TOOLS_DIR="${TOOLS_DIR}"

RUN git config --global advice.detachedHead false

WORKDIR /build
COPY build.sh .
RUN chmod +x ./build.sh
