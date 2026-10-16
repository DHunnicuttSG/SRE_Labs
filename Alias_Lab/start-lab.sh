#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/alias_practice" ]]; then
  bash /opt/alias-lab/setup.sh
fi

printf 'Linux Alias and Functions Lab\nWorkspace: %s/alias_practice\n\n' "$HOME"
exec bash