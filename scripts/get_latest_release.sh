#!/bin/bash

## Check Latest Release
LATEST_RELEASE=$(curl -Ls 'https://api.github.com/repos/pgbouncer/pgbouncer.github.io/contents/downloads/files' | jq -r '[.[].name] | sort_by( values | split(".") | map(tonumber) ) | .[-1]')

## Build image if not on docker hub
if docker manifest inspect iloveyatoo/pgbouncer:$LATEST_RELEASE >/dev/null; then
    echo "Image already exists"
    exit 0
else
    cd ~/docker-pgbouncer
    ls
    docker build -t iloveyatoo/pgbouncer:$LATEST_RELEASE --build-arg PGBOUNCER_VERSION=$LATEST_RELEASE --no-cache .
    docker push iloveyatoo/pgbouncer:$LATEST_RELEASE
fi