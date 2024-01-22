#!/usr/bin/env bash
set -e

GITHUB_URL="https://api.github.com/repos/$GITHUB_REPOSITORY"
DOCKER_REPO="europe-north1-docker.pkg.dev/$PROJECT_ID/$TEAM"
# Checking if too many drafts before starting the deploy
DRAFTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_URL/releases?per_page=20" | jq -r '. | map(select(.draft == true)) | length')
if [[ "$DRAFTS" -gt "$DRAFTS_MAX" ]]; then
  echo "you have too many release drafts max $DRAFT_MAX in queue, please release to production or clean up drafts!"
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
  VERSION_TAG=$(TZ=Europe/Oslo date +"%y.%j.%H%M%S")
else
  VERSION_TAG=$VERSION_TAG
fi
if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=$DOCKER_REPO/$APPLICATION
fi

if [ -z "$IMAGE_SUFFIX" ]; then
  IMAGE=$DOCKER_IMAGE:$VERSION_TAG
  DRAFT_NAME="$APPLICATION $VERSION_TAG"
else
  IMAGE=$DOCKER_IMAGE-$IMAGE_SUFFIX:$VERSION_TAG
  DRAFT_NAME="$APPLICATION/$IMAGE_SUFFIX $VERSION_TAG"
fi

echo "VERSION_TAG=$VERSION_TAG" >> "$GITHUB_ENV"
echo "APPLICATION=$APPLICATION" >> "$GITHUB_ENV"
echo "IMAGE=$IMAGE" >> "$GITHUB_ENV"
echo "DRAFT_NAME=$DRAFT_NAME" >> "$GITHUB_ENV"
