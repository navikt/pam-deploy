#!/usr/bin/env bash
# This script generates the file /docs/index.md

PAMFOLDER=$1
if [ -z "$PAMFOLDER" ]; then
  PAMFOLDER=$(pwd)
fi

echo "searching for pam projects in $PAMFOLDER"

names=()

while IFS= read -r line; do
    names+=( "$line" )
done < <(find $PAMFOLDER -name "deploy-dev.yml" | sort | rev | cut -d '/' -f 4 | rev )

FILE="index.md"

echo "# PAM deployments" > $FILE
echo "|    |    |    |    |" >> $FILE
echo "|:---|:---|:---|:---|" >> $FILE
count=0

for name in "${names[@]}"
do
   if [[ "$name" == pam-* ]]; then
      echo "found project $name"
      count=`expr $count + 1`
      remainder=`expr $count % 4`
      printf "| [$name](https://github.com/navikt/$name/actions) [![build-deploy-dev](https://github.com/navikt/$name/workflows/build-deploy-dev/badge.svg)](https://github.com/navikt/$name/releases) [![deploy-prod](https://github.com/navikt/$name/workflows/deploy-prod/badge.svg)](https://github.com/navikt/$name/releases/latest) " >> $FILE
      if [ "$remainder" == "0" ]; then
        printf "|\n" >> $FILE
      fi
   fi
done

echo "generated $FILE, move it to pam-deploy/docs/"