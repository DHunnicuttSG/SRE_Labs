#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  printf 'Account and group setup requires root. Use the disposable Docker lab or a disposable Linux VM.\n' >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lab_dir="/opt/user_group_admin_practice"
lab_users=(lab_alice lab_bob lab_auditor)

if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

if getent group project_team >/dev/null; then
  printf 'Refusing to reuse existing group project_team.\n' >&2
  exit 1
fi

for username in "${lab_users[@]}"; do
  if getent passwd "$username" >/dev/null; then
    printf 'Refusing to reuse existing user %s.\n' "$username" >&2
    exit 1
  fi
done

for username in "${lab_users[@]}"; do
  useradd --create-home --user-group --shell /bin/bash "$username"
done

mkdir -p "$lab_dir/reports"
cp -R "$script_dir/dataset/." "$lab_dir/"
chown -R root:root "$lab_dir"
chmod 0755 "$lab_dir" "$lab_dir/shared_project" "$lab_dir/private_project" "$lab_dir/reports"
chmod 0644 "$lab_dir/shared_project/README.txt" "$lab_dir/private_project/budget.txt"

printf 'User/group admin practice initialized at %s\n' "$lab_dir"
printf 'Created users: %s\n' "${lab_users[*]}"
printf 'The project_team group is yours to create in the exercise.\n'