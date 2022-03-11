#!/bin/bash

## Check Latest Release
LATEST_RELEASE=$(curl -Ls 'https://api.github.com/repos/pgbouncer/pgbouncer.github.io/contents/downloads/files' | jq -r '[.[].name] | sort_by( values | split(".") | map(tonumber) ) | .[-1]')

## Split Latest Release into array
IFS='.' read -r -a LATEST_RELEASE_SPLIT <<< "$LATEST_RELEASE"

## Generate URL 
LATEST_RELEASE_URL="https://github.com/pgbouncer/pgbouncer/releases/download/pgbouncer_${LATEST_RELEASE_SPLIT[0]}_${LATEST_RELEASE_SPLIT[1]}_${LATEST_RELEASE_SPLIT[2]}/pgbouncer-1.16.1.tar.gz"

wget $LATEST_RELEASE_URL