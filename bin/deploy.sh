#!/usr/bin/env bash

set -euo pipefail

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

"$DIRECTORY/update.sh" && "$DIRECTORY/converge.sh" "$@"
