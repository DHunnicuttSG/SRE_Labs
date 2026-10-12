#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/sed_practice" ]]; then
  bash /opt/sed-lab/setup.sh
fi

printf 'Linux Sed Lab\nWorkspace: %s/sed_practice\n\n' "$HOME"
exec bash