#!/usr/bin/env bash
set -e
DRAFTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases?per_page=20" | jq -r '. | map(select(.draft == true)) | length')
if [[ "$DRAFTS" -gt "10" ]]; then
  echo "you have too many release drafts in queue, please release to production or clean up drafts!"
  exit 1
fi
APPLICATION=$(echo $GITHUB_REPOSITORY | cut -d "/" -f 2)
VERSION_TAG=$(TZ=Europe/Oslo date +"%y.%j.%H%M%S")
if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=docker.pkg.github.com/$GITHUB_REPOSITORY/$APPLICATION
fi
IMAGE=$DOCKER_IMAGE:$VERSION_TAG
echo "::set-env name=VERSION_TAG::$VERSION_TAG"
echo "::set-env name=APPLICATION::$APPLICATION"
echo "::set-env name=IMAGE::$IMAGE"
