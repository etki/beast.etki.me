#!/usr/bin/env bash

set -euo pipefail

ROOT="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" >/dev/null 2>&1 && pwd )"

cd "$ROOT/workspace"
knife zero bootstrap beast.etki.me -N beast.etki.me --overwrite --policy-name satellite.etki.me --policy-group local "$@"
