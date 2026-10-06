FROM docker.io/library/debian:13-slim AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    clang-18 \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libblocksruntime-dev \
    libc++-18-dev \
    libc++abi-18-dev \
    libclang-rt-18-dev \
    libusb-1.0-0 \
    llvm-18-dev \
    make \
    python3 \
    python3-intelhex \
    python3-venv \
    unzip \
    xxd \
    xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 100

RUN git config --system safe.directory '*' && \
    git config --system advice.detachedHead false

ENV TOOLS_DIR=/opt/betaflight/tools

FROM base AS source

ARG BETAFLIGHT_REPO="https://github.com/betaflight/betaflight.git"
ARG BETAFLIGHT_REF="master"

WORKDIR /betaflight
RUN git init -q && \
    git remote add origin "${BETAFLIGHT_REPO}" && \
    git fetch -q --depth 1 origin "${BETAFLIGHT_REF}" && \
    git checkout -q FETCH_HEAD

FROM source AS tools

ARG SDK="arm"

# Tools are installed at their final path as the ESP-IDF python venv is not relocatable.
RUN if [ "${SDK}" = "arm" ]; then \
        make arm_sdk_install; \
    else \
        make SDK="${SDK}" platform-tools-install; \
    fi && \
    rm -rf "${TOOLS_DIR}/espressif/dist"

FROM base

ARG BETAFLIGHT_REF="master"
ARG SDK="arm"

LABEL org.opencontainers.image.title="betaflight-build" \
      org.opencontainers.image.description="Betaflight firmware build toolchain (${SDK} SDK)" \
      org.opencontainers.image.revision="${BETAFLIGHT_REF}" \
      org.opencontainers.image.source="https://github.com/betaflight/betaflight-build" \
      org.opencontainers.image.licenses="GPL-3.0"

COPY --from=tools ${TOOLS_DIR} ${TOOLS_DIR}

WORKDIR /src
