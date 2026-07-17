#!/usr/bin/env bash
set -e

if [ -n "$GITHUB_WORKSPACE" ]; then
  git config --global --add safe.directory $GITHUB_WORKSPACE
  cd "$GITHUB_WORKSPACE" || exit
fi
# security reasons

if [ -z "$VERSION_TAG" ]; then
  echo "VERSION_TAG is required. Ensure pre-deploy ran first, or pass VERSION_TAG explicitly to the workflow."
  exit 1
fi

if [ -z "$DRY_RUN" ]; then
   git remote set-url origin "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
   git tag -f "$VERSION_TAG"
   git push -f --tags
fi
