#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/awk_practice" ]]; then
  bash /opt/awk-lab/setup.sh
fi

printf 'Linux Awk Lab\nWorkspace: %s/awk_practice\n\n' "$HOME"
exec bash