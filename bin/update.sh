#!/usr/bin/env bash

set -euo pipefail

ROOT="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" >/dev/null 2>&1 && pwd )"

POLICYFILE="$ROOT/cookbooks/beast.etki.me/Policyfile.lock.json"
POLICYFILE_LOCK="$ROOT/cookbooks/beast.etki.me/Policyfile.lock.json"
WORKSPACE="$ROOT/workspace"

if [ -f "$POLICYFILE_LOCK" ]; then
  chef update "$POLICYFILE"
else
  chef install "$POLICYFILE"
fi

chef export "$POLICYFILE" "$WORKSPACE" --force
cp -r "$ROOT/data_bags" "$WORKSPACE/"
