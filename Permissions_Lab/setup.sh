#!/usr/bin/env bash
set -euo pipefail

lab_dir="/home/student/permissions_lab"
if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir"/{files,directories,symbolic,umask,troubleshooting,conversion,stretch,combined}

printf 'Read this report; only its owner should edit it.\n' > "$lab_dir/files/report.txt"
printf 'Private notes for the owner.\n' > "$lab_dir/files/secret.txt"
printf 'Shared notes for the developers group.\n' > "$lab_dir/files/team_notes.txt"
cat > "$lab_dir/files/backup.sh" <<'EOF'
#!/bin/sh
printf 'Backup task ran.\n'
EOF
printf 'Inventory pending reassignment.\n' > "$lab_dir/files/inventory.txt"

mkdir -p "$lab_dir/directories/finance" "$lab_dir/directories/projectA"
printf 'Owner-only finance records.\n' > "$lab_dir/directories/finance/records.txt"
printf 'Shared project notes.\n' > "$lab_dir/directories/projectA/notes.txt"

printf 'Starting symbolic permissions: rw-r-----.\n' > "$lab_dir/symbolic/file.txt"
cat > "$lab_dir/troubleshooting/backup.sh" <<'EOF'
#!/bin/sh
printf 'Troubleshooting script ran.\n'
EOF

printf 'Convert rwxr-x--- to octal.\n' > "$lab_dir/conversion/750.txt"
printf 'Convert rw-rw-r-- to octal.\n' > "$lab_dir/conversion/664.txt"
printf 'Convert rwxrwxrwx to octal.\n' > "$lab_dir/conversion/777.txt"
printf 'Convert r-------- to octal.\n' > "$lab_dir/conversion/400.txt"

for mode in 640 755 700 775; do
  printf 'Set this file to mode %s using symbolic notation.\n' "$mode" > "$lab_dir/stretch/$mode.txt"
done

cat > "$lab_dir/combined/backup.sh" <<'EOF'
#!/bin/sh
printf 'Combined task ran as %s.\n' "$(id -un)"
EOF

chmod 0644 "$lab_dir/files/report.txt" \
  "$lab_dir/files/secret.txt" \
  "$lab_dir/files/team_notes.txt" \
  "$lab_dir/files/inventory.txt" \
  "$lab_dir/symbolic/file.txt" \
  "$lab_dir/troubleshooting/backup.sh" \
  "$lab_dir/conversion/"*.txt \
  "$lab_dir/stretch/"*.txt \
  "$lab_dir/combined/backup.sh"
chmod 0755 "$lab_dir/files/backup.sh"
chmod 0755 "$lab_dir/directories" "$lab_dir/files" "$lab_dir/symbolic" \
  "$lab_dir/umask" "$lab_dir/troubleshooting" "$lab_dir/conversion" \
  "$lab_dir/stretch" "$lab_dir/combined"
chmod 0755 "$lab_dir/directories/finance" "$lab_dir/directories/projectA"