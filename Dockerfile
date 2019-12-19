FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y golang-go gcc-arm-linux-gnueabi git

ENV GOOS linux
ENV GOARCH arm
ENV GOARM 6
ENV CGO_ENABLED 1
ENV CC arm-linux-gnueabi-gcc

ARG CLOUDFLARED_VERSION=2019.11.3

RUN mkdir -p /opt/cloudflared-build/out
WORKDIR /opt/cloudflared-build
RUN git clone -b ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared.git /opt/cloudflared-build/cloudflared
WORKDIR /opt/cloudflared-build/cloudflared
RUN go build -v "-ldflags=-X 'main.Version=${CLOUDFLARED_VERSION}' -X 'main.BuildTime=$(date)'" github.com/cloudflare/cloudflared/cmd/cloudflared && \
    mv cloudflared /opt/cloudflared-build/out
WORKDIR /opt/cloudflared-build/out
