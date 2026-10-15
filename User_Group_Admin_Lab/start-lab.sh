#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d /opt/user_group_admin_practice ]]; then
  bash /opt/user-group-admin-lab/setup.sh
fi

printf 'Linux User and Group Administration Lab\nWorkspace: /opt/user_group_admin_practice\n\n'
exec bash