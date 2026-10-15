#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/redirection_practice" ]]; then
  bash /opt/redirection-pipes-lab/setup.sh
fi

printf 'Linux Redirection and Pipes Lab\nWorkspace: %s/redirection_practice\n\n' "$HOME"
exec bash