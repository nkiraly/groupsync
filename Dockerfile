# syntax = docker/dockerfile:1.2

# NOTICE: this image is intended to be built with buildx
# the args TARGETPLATFORM and BUILDPLATFORM are provided when building with buildx
# specify args outside build stage to use them in FROM
ARG TARGET_BASE=scratch

# build groupsync for target platform
FROM --platform=$TARGETPLATFORM golang AS build
# make required args outside stage available inside
ARG TARGETPLATFORM
ARG BUILDPLATFORM
# plus build-stage specific args with defaults here
ARG TARGET_OS=linux
ARG TARGET_ARCH=amd64

RUN echo "Running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /groupsync

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=$TARGET_OS \
    GOARCH=$TARGET_ARCH

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build


# create application container from minimal base image, copying in the built binary
FROM --platform=$TARGETPLATFORM $TARGET_BASE as groupsync

COPY --from=build groupsync /

ENTRYPOINT ["/groupsync"]
