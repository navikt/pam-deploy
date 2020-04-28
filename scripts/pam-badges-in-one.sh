#!/usr/bin/env bash
# This script generates the file /docs/index.md

names=()

while IFS= read -r line; do
    names+=( "$line" )
done < <(find . -name "deploy-dev.yml" | sort | cut -d '/' -f 2)

echo "# PAM deployments" > index.md
echo "|    |    |    |    |" >> index.md
echo "|:---|:---|:---|:---|" >> index.md
count=0

for name in "${names[@]}"
do
   if [ "$name" != "pam-scripts" ]; then
      count=`expr $count + 1`
      remainder=`expr $count % 4`
      printf "| $name ![build-deploy-dev](https://github.com/navikt/$name/workflows/build-deploy-dev/badge.svg) ![deploy-prod](https://github.com/navikt/$name/workflows/deploy-prod/badge.svg) " >> index.md
      if [ "$remainder" == "0" ]; then
        printf "|\n" >> index.md
      fi
   fi
done
