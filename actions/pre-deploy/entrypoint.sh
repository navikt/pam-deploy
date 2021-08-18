#!/usr/bin/env bash
set -e

GITHUB_URL="https://api.github.com/repos/$GITHUB_REPOSITORY"
DOCKER_REPO="ghcr.io"
# Checking if too many drafts before starting the deploy
DRAFTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_URL/releases?per_page=20" | jq -r '. | map(select(.draft == true)) | length')
if [[ "$DRAFTS" -gt "10" ]]; then
  echo "you have too many release drafts in queue, please release to production or clean up drafts!"
  exit 1
fi

# Detecting conflicting runs
while read -r id; do
  if [[ "$id" < "$GITHUB_RUN_ID" ]]; then
    echo "cancel in progress workflow runs to avoid conflicts"
    curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_URL/actions/runs/$id/cancel"
  fi
done < <(curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_URL/actions/runs?event=push&status=in_progress&branch=master" | jq -r '.workflow_runs[].id')

APPLICATION=$(echo $GITHUB_REPOSITORY | cut -d "/" -f 2)
if [ -z "$VERSION_TAG" ]; then
  VERSION_TAG=$VERSION_TAG
else
  VERSION_TAG=$(TZ=Europe/Oslo date +"%y.%j.%H%M%S")
fi
if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=$DOCKER_REPO/$GITHUB_REPOSITORY
fi
IMAGE=$DOCKER_IMAGE:$VERSION_TAG

echo "building and push docker image"
echo $GITHUB_TOKEN | docker login --username $GITHUB_REPOSITORY --password-stdin $DOCKER_REPO
if [ -z "$DRY_RUN" ]; then
  docker build . --pull -t $IMAGE
  docker push $IMAGE
fi

echo "VERSION_TAG=$VERSION_TAG" >> "$GITHUB_ENV"
echo "APPLICATION=$APPLICATION" >> "$GITHUB_ENV"
echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
