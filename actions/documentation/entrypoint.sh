#!/usr/bin/env bash
set -e
echo "Hello before parser"
/go/naisparser
CONTENT=$(<tmp.json)
echo "Hello after parser"

echo "NAIS_CONTNENT=$CONTENT" >> "$GITHUB_ENV"
echo $GITHUB_ENV