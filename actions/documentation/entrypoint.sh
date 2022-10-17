#!/usr/bin/env bash
set -e

# run go naisparser module
/go/naisparser

#Get content from tmpl file
CONTENT=$(<tmp.json)

#Set content as github environment
echo "NAIS_CONTNENT=$CONTENT" >> "$GITHUB_ENV"
