#!/usr/bin/env bash
set -e
if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=$PAM_DOCKER_HOST/$GITHUB_REPOSITORY
fi
IMAGE=$DOCKER_IMAGE:$VERSION_TAG
echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
