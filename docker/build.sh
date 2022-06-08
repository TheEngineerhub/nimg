#!/usr/bin/env bash

if [[ -z "${NIMG_TAG}" ]]; then
  IMAGE_TAG=stage
else
  IMAGE_TAG="${NIMG_TAG}"
fi

printf "=> Build tag: %s\n" "${IMAGE_TAG}"

build() {
  docker buildx build -t engineerhub/nimg:"$IMAGE_TAG" -t engineerhub/nimg:latest --platform linux/arm64,linux/amd64 -f docker/build.Dockerfile --push .
  exit 1
}

if [[ $(docker buildx ls) =~ "multiarch" ]]; then
  printf "=> Found build environment\n"
  printf "=> Building image for linux/arm64,linux/amd64\n"
  build
else
  printf "=> Creating build environment\n"
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  docker buildx create --name multiarch --driver docker-container --use
  docker buildx inspect --bootstrap
  build
fi
