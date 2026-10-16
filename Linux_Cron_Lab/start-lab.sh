#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  printf 'The Docker entrypoint must start as root to launch cron.\n' >&2
  exit 1
fi

cron

if [[ ! -d /home/student/cron_practice ]]; then
  su - student -s /bin/bash -c 'bash /opt/linux-cron-lab/setup.sh'
fi

printf 'Linux Cron Jobs Lab\nWorkspace: /home/student/cron_practice\n\n'
exec su - student -s /bin/bash