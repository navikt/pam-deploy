#!/usr/bin/env bash
set -e

if [ -n "$GITHUB_WORKSPACE" ]; then
  git config --global --add safe.directory $GITHUB_WORKSPACE
  cd "$GITHUB_WORKSPACE" || exit
fi

# run go naisparser module
/go/naisparser


#Get content from tmpl file
CONTENT=$(<tmp.json)
if [ ! -d ".doc" ]; then
  mkdir -p ".doc"
fi
echo $CONTENT >> .doc/app.json

# BASE_CONTENT=$(echo $CONTENT | base64)

# git add .doc/app.json
# curl \
#   -X PUT \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer ${GITHUB_TOKEN}" \
#   https://api.github.com/repos/navikt/${GITHUB_REPOSITORY}/contents/.doc/app.json \
#   -d "{'message':'update','committer':{'name': 'GitHub Action', 'email':'action@github.com'},'content': ${BASE_CONTENT}}"

# rm tmp.json

# git remote set-url origin "https://${GITHUB_ACTOR}:@github.com/${GITHUB_REPOSITORY}.git"

# git push -f
