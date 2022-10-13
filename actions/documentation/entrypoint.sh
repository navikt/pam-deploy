#!/usr/bin/env bash
set -e

RES=$(gh api -H "Accept: application/vnd.github.v3.raw" /repos/navikt/pam-doc/contents/README.md)
echo $RES