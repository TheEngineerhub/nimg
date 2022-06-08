#!/usr/bin/env bash

if [[ -z "${NIMG_TAG}" ]]; then
  IMAGE_TAG=stage
else
  IMAGE_TAG="${NIMG_TAG}"
fi

echo "=> Build tag: ${NIMG_TAG}\n"

if [[ $(docker buildx ls) =~ "multiarch" ]]; then
  echo "=> Found build environment\n"
  echo "=> Building image for linux/arm64,linux/amd64\n"
  docker buildx build -t engineerhub/nimg:$IMAGE_TAG --platform linux/arm64,linux/amd64 -f docker/build.Dockerfile --push .
else
  echo "=> Creating build environment\n"
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  docker buildx create --name multiarch --driver docker-container --use
  docker buildx inspect --bootstrap
fi
