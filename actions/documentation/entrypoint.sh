#!/usr/bin/env bash
set -e

# run go naisparser module
/go/naisparser

#Get content from tmpl file
CONTENT=$(<tmp.json)

#Set content as github environment
# echo "NAIS_CONTENT=$CONTENT" >> "$GITHUB_ENV"
curl  \
REPOS=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer {$GITHUB_TOKEN}" \
  https://api.github.com/repos/navikt/pam-repoinfo/contents/repos.json)
echo $REPOS
