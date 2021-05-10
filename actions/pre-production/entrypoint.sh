#!/usr/bin/env bash
set -e
IMAGE=ghcr.io/$GITHUB_REPOSITORY:$VERSION_TAG
echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
