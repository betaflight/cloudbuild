FROM betaflight/cloudbuild:ARM9.3

ARG COMMIT="master"
ARG REPO="https://github.com/betaflight/betaflight.git"

RUN echo "$REPO $COMMIT"

RUN git clone -b ${COMMIT} ${REPO} source

WORKDIR /source

RUN git checkout ${COMMIT}

ARG NOCACHE="1"

RUN git pull origin ${COMMIT}:${COMMIT}

RUN make configs

WORKDIR /build
COPY build.sh .

RUN chmod +x ./build.sh
