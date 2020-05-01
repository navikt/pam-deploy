#!/usr/bin/env bash
set -e

GITHUB_URL="https://api.github.com/repos/$GITHUB_REPOSITORY"

DRAFTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_URL/releases?per_page=20" | jq -r '. | map(select(.draft == true)) | length')
if [[ "$DRAFTS" -gt "10" ]]; then
  echo "you have too many release drafts in queue, please release to production or clean up drafts!"
  exit 1
fi

# Detecting conflicting runs
while read -r id; do
  if [[ "$id" < "$GITHUB_RUN_ID" ]]; then
    echo "cancel in progress workflow runs to avoid conflicts"
    curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs/$id/cancel"
  fi
done < <(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs?event=push&status=in_progress&branch=master" | jq -r '.workflow_runs[].id')

APPLICATION=$(echo $GITHUB_REPOSITORY | cut -d "/" -f 2)
VERSION_TAG=$(TZ=Europe/Oslo date +"%y.%j.%H%M%S")
if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=docker.pkg.github.com/$GITHUB_REPOSITORY/$APPLICATION
fi
IMAGE=$DOCKER_IMAGE:$VERSION_TAG
echo "::set-env name=VERSION_TAG::$VERSION_TAG"
echo "::set-env name=APPLICATION::$APPLICATION"
echo "::set-env name=IMAGE::$IMAGE"
