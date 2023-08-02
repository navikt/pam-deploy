#!/usr/bin/env bash
set -e

DOCKER_REPO="europe-north1-docker.pkg.dev/$PROJECT_ID/$TEAM"

if [ -z "$APPLICATION" ]; then
  APPLICATION=$(echo $GITHUB_REPOSITORY | cut -d "/" -f 2)
fi

if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=$DOCKER_REPO/$APPLICATION
fi

if [ -z "$IMAGE_SUFFIX" ]; then
  IMAGE=$DOCKER_IMAGE:$VERSION_TAG
else
  IMAGE=$DOCKER_IMAGE/$IMAGE_SUFFIX:$VERSION_TAG
fi

echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
