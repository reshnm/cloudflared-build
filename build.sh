#!/usr/bin/env bash

CLOUDFLARED_VERSION=$1

if [ -z $CLOUDFLARED_VERSION ]; then
    docker build -t cloudflared_arm_build .
else
    docker build --build-arg CLOUDFLARED_VERSION=$CLOUDFLARED_VERSION -t cloudflared_arm_build .
fi

docker run --name cloudflared_arm_build -dt --rm cloudflared_arm_build cat
docker cp $(docker ps -qf "name=cloudflared_arm_build"):/opt/cloudflared-build/out/cloudflared .
docker stop $(docker ps -qf "name=cloudflared_arm_build")
