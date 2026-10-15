#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/find_practice" ]]; then
  bash /opt/linux-find-lab/setup.sh
fi

printf 'Linux Find and Locate Lab\nWorkspace: %s/find_practice\n\n' "$HOME"
exec bash