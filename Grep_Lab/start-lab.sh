#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/grep_practice" ]]; then
  bash /opt/grep-lab/setup.sh
fi

printf 'Linux Grep Lab\nWorkspace: %s/grep_practice\n\n' "$HOME"
exec bash