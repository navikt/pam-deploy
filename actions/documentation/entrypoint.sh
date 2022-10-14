#!/usr/bin/env bash
set -e
echo "Hello before parser"
/go/naisparser
CONTENT=$(<tmp.json)
echo $CONTENT
echo "hello after parser"

echo "NAIS_CONTNENT=$CONTENT" >> "$GITHUB_ENV"
echo $GITHUB_ENV
echo "hello echo env var"
