#!/usr/bin/env bash
set -e
echo "Hello before parser"
/go/naisparser
CONTENT=$(<tmp.json)
echo "Hello after parser"
cat tmp.json
echo "hello after cat"

echo "NAIS_CONTNENT=$CONTENT" >> "$GITHUB_ENV"
echo $GITHUB_ENV
echo "hello echo env var"
