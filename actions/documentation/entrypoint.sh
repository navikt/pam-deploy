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

