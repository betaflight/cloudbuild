ARG NOCACHE="0"
ARG TAG="master"

FROM betaflight/cloudbuild:${TAG} AS base
WORKDIR /source

RUN git pull origin

RUN make configs
