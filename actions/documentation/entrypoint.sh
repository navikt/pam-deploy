#!/usr/bin/env bash
set -e

# run go naisparser module
/go/naisparser

#Get content from tmpl file
CONTENT=$(<tmp.json)
echo $CONTENT

#Get content as base64
BASE_CONTENT=$(echo $CONTENT | base64)
echo $BASE_CONTENT

echo "BASE_CONTENT=$BASE_CONTENT" >> "$GITHUB_ENV"
