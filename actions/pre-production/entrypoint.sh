#!/usr/bin/env bash
set -e

DOCKER_REPO="europe-north1-docker.pkg.dev/$PROJECT_ID/$TEAM"

if [ -z "$APPLICATION" ]; then
  APPLICATION=$(echo $GITHUB_REPOSITORY | cut -d "/" -f 2)
fi

if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=$DOCKER_REPO/$APPLICATION
fi
IMAGE=$DOCKER_IMAGE:$VERSION_TAG
echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
