#!/bin/bash

set -e

pushd omb/dockerfiles

echo -e "OMB native\n\n"
docker build --no-cache -t omb_native -f Dockerfile_native .
echo -e "\n\n OMB Scone\n\n"
docker build --no-cache -t omb_scone -f Dockerfile_scone .
popd

pushd prb/dockerfiles
echo -e "\n\nPRB native\n\n"
docker build --no-cache -t prb_native -f Dockerfile_native .
echo -e "\n\nPRB Scone\n\n"
docker build --no-cache -t prb_scone -f Dockerfile_scone .
popd

docker images | egrep "omb|prb"
