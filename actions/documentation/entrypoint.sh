#!/usr/bin/env bash
set -e

# run go naisparser module
/go/naisparser

#Get content from tmpl file
CONTENT=$(<tmp.json)
if [ ! -d ".doc" ]; then
  mkdir -p ".doc"
fi
echo $CONTENT >> .doc/app.json

rm tmp.json

if [ -n "$GITHUB_WORKSPACE" ]; then
  git config --global --add safe.directory $GITHUB_WORKSPACE
  cd "$GITHUB_WORKSPACE" || exit
fi

git add .doc/app.json
