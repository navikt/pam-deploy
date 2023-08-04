#!/usr/bin/env bash
set -e

LATEST_RELEASE_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest" | jq -r '.id')

echo $LATEST_RELEASE_ID

while IFS="|" read -r id tagname name ; do
  if [ -z "$IMAGE_SUFFIX" ]; then
    delete=true
  else
    application=$(echo ${name#"$GITHUB_REPOSITORY"/} | awk '{ print $1 }')
    echo "Current application is $application"
    if [[ "$application" == "$IMAGE_SUFFIX" ]]; then
      delete=true
    else
      delete=false
    fi
  fi

  if [[ "$id" < "$LATEST_RELEASE_ID" ]] && [[ $delete == true ]]; then
    echo "deleting draft release $tagname"
    if [ -z "$DRY_RUN" ]; then
      curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/$id"
    fi
  fi
done < <(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases?per_page=20" | jq -r '.[] | select(.draft == true)' | jq -r '"\(.id)|\(.tag_name)|\(.name)"')
