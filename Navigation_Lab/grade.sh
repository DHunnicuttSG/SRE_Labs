#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/navigation_lab"
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

is_empty_file() {
  [[ -f "$1" && ! -s "$1" ]]
}

printf 'Checking exercise at %s\n\n' "$lab_dir"
check 10 'archive directory exists' test -d "$lab_dir/archive"
check 10 'deliverables directory exists' test -d "$lab_dir/deliverables"
check 10 'copied field notes exist' test -f "$lab_dir/deliverables/field-notes.txt"
check 15 'copied field notes match the original' cmp -s "$lab_dir/inbox/field-notes.txt" "$lab_dir/deliverables/field-notes.txt"
check 5 'original field notes remain in inbox' test -f "$lab_dir/inbox/field-notes.txt"
check 5 'checked.txt exists' test -f "$lab_dir/deliverables/checked.txt"
check 5 'checked.txt is empty' is_empty_file "$lab_dir/deliverables/checked.txt"
check 10 'old map exists in archive' test -f "$lab_dir/archive/old-map.txt"
check 10 'archived map has the expected contents' cmp -s "$lab_dir/archive/old-map.txt" <(printf 'Old map: the east path is closed.\n')
check 5 'old map is no longer in inbox' test ! -e "$lab_dir/inbox/old-map.txt"
check 5 'temporary draft was removed' test ! -e "$lab_dir/work/draft.tmp"
check 10 'empty-room directory was removed' test ! -e "$lab_dir/empty-room"

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review the failed checks, make corrections, and run the grader again.\n'
exit 1