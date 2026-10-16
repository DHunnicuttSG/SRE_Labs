#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/links_practice" ]]; then
  bash /opt/hard-soft-links-lab/setup.sh
fi

printf 'Linux Hard and Soft Links Lab\nWorkspace: %s/links_practice\n\n' "$HOME"
exec bash