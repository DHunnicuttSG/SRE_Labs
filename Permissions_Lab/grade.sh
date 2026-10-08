#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/permissions_lab"
score=0
total=100

check() {
  local points="$1"
  local label="$2"
  shift 2

  if "$@"; then
    printf '[PASS] %s (+%d)\n' "$label" "$points"
    score=$((score + points))
  else
    printf '[FAIL] %s (%d points)\n' "$label" "$points"
  fi
}

has_mode() {
  [[ -f "$1" || -d "$1" ]] && [[ "$(stat -c '%a' "$1")" == "$2" ]]
}

has_owner_group() {
  [[ -e "$1" ]] \
    && [[ "$(stat -c '%U:%G' "$1")" == "$2:$3" ]]
}

has_umask_results() {
  [[ -f "$lab_dir/umask/new-file.txt" ]] \
    && [[ -d "$lab_dir/umask/new-directory" ]] \
    && [[ "$(stat -c '%a' "$lab_dir/umask/new-file.txt")" == 640 ]] \
    && [[ "$(stat -c '%a' "$lab_dir/umask/new-directory")" == 750 ]]
}

has_conversion_modes() {
  has_mode "$lab_dir/conversion/750.txt" 750 \
    && has_mode "$lab_dir/conversion/664.txt" 664 \
    && has_mode "$lab_dir/conversion/777.txt" 777 \
    && has_mode "$lab_dir/conversion/400.txt" 400
}

has_stretch_modes() {
  has_mode "$lab_dir/stretch/640.txt" 640 \
    && has_mode "$lab_dir/stretch/755.txt" 755 \
    && has_mode "$lab_dir/stretch/700.txt" 700 \
    && has_mode "$lab_dir/stretch/775.txt" 775
}

printf 'Checking permission exercises in %s\n\n' "$lab_dir"
check 8 'report.txt is 644' has_mode "$lab_dir/files/report.txt" 644
check 8 'secret.txt is 600' has_mode "$lab_dir/files/secret.txt" 600
check 8 'team_notes.txt is 660' has_mode "$lab_dir/files/team_notes.txt" 660
check 8 'backup.sh is executable by everyone (755)' has_mode "$lab_dir/files/backup.sh" 755
check 8 'finance directory is owner-only (700)' has_mode "$lab_dir/directories/finance" 700
check 8 'projectA is 770' has_mode "$lab_dir/directories/projectA" 770
check 8 'projectA group is developers' has_owner_group "$lab_dir/directories/projectA" student developers
check 8 'inventory ownership is student1:developers' has_owner_group "$lab_dir/files/inventory.txt" student1 developers
check 8 'symbolic changes result in 464' has_mode "$lab_dir/symbolic/file.txt" 464
check 10 'umask 027 creates a 640 file and 750 directory' has_umask_results
check 6 'troubleshooting script has owner execute (744)' has_mode "$lab_dir/troubleshooting/backup.sh" 744
check 6 'octal conversion files match their permissions' has_conversion_modes
check 6 'stretch files match symbolic permission targets' has_stretch_modes

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review the failed checks, make corrections, and run the grader again.\n'
exit 1