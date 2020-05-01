#!/usr/bin/env bash
set -e

if [ -n "$GITHUB_WORKSPACE" ]; then
  cd "$GITHUB_WORKSPACE" || exit
fi

if ! git describe --abbrev=0 --tags &>/dev/null; then
  FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)
  git tag "CD_autocreate_tag" $FIRST_COMMIT
  echo "No tags found. Created one on the initial commit"
fi

LATEST_TAG=$(git describe --abbrev=0 --tags)

if [ -z "$DRY_RUN" ]; then
   git remote set-url origin "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
   git tag -f $VERSION_TAG
   git push -f --tags
fi

LATEST_RELEASE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest" | jq -r '.tag_name')
if [ "$LATEST_RELEASE" = "null" ]; then LATEST_RELEASE=$LATEST_TAG; fi
echo "Found latest release: $LATEST_RELEASE"
GIT_TREE="[$VERSION_TAG](https://github.com/$GITHUB_REPOSITORY/tree/$VERSION_TAG)"
COMPARE_LINK="[Full Changelog](https://github.com/$GITHUB_REPOSITORY/compare/$LATEST_RELEASE...$VERSION_TAG)"
GIT_LOG=$(git log $LATEST_RELEASE..$VERSION_TAG --no-merges --pretty=format:"* %ad %s" -50 --date=short | sed "/^\\s*$/d")
CHANGELOG="$GIT_TREE%0A$COMPARE_LINK%0A$GIT_LOG"
CHANGELOG="${CHANGELOG//$'\n'/'%0A'}"
CHANGELOG="${CHANGELOG//$'\r'/'%0D'}"
echo "::set-env name=CHANGE_LOG::$CHANGELOG"
