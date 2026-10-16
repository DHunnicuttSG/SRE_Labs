#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/environment_variables_practice" ]]; then
  bash /opt/environment-variables-lab/setup.sh
fi

source "$HOME/environment_variables_practice/lab-env.sh"
cd "$HOME/environment_variables_practice"
printf 'Linux Environment Variables Lab\nWorkspace: %s/environment_variables_practice\n\n' "$HOME"
exec bash
