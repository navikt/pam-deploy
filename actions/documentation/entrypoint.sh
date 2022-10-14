#!/usr/bin/env bash
set -e

/go/naisparser
CONTENT=$(<tmp.json)

echo "NAIS_CONTNENT=$CONTENT" >> "$GITHUB_ENV"
echo $GITHUB_ENV