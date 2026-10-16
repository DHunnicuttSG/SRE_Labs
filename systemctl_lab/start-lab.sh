#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/systemctl_practice" ]]; then
  bash /opt/systemctl-lab/setup.sh
fi

source "$HOME/systemctl_practice/lab-env.sh"
cd "$HOME/systemctl_practice"
printf 'Linux systemctl and journalctl Lab\nWorkspace: %s/systemctl_practice\nRead-only fixture commands are active in this shell.\n\n' "$HOME"
exec bash
