#!/usr/bin/env bash

set -euo pipefail

ROOT="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" >/dev/null 2>&1 && pwd )"

cd "$ROOT/workspace"
knife zero bootstrap satellite.etki.me -N satellite.etki.me --overwrite --policy-name satellite.etki.me --policy-group local "$@"
