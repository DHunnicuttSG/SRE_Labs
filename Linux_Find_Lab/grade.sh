#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/find_practice"
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

check_report() {
  local report="$1"
  shift
  [[ -f "$report" ]] || return 1

  local expected
  expected="$(mktemp)" || return 1
  if "$@" > "$expected"; then
    cmp -s "$expected" "$report"
    local result=$?
    rm -f "$expected"
    return "$result"
  fi

  rm -f "$expected"
  return 1
}

expected_q01() { find tree -type f -name '*.conf' -print | LC_ALL=C sort; }
expected_q02() { find tree -type f -iname '*.md' -print | LC_ALL=C sort; }
expected_q03() { find tree -type d -print | LC_ALL=C sort; }
expected_q04() { find tree -type f -size +50c -print | LC_ALL=C sort; }
expected_q05() { find tree -type f -mtime +7 -print | LC_ALL=C sort; }
expected_q06() { find tree -type f -perm 0640 -print | LC_ALL=C sort; }
expected_q07() { find tree -type f \( -name '*.conf' -o -name '*.log' \) -print | LC_ALL=C sort; }
expected_q08() { find tree -type f -empty -print | LC_ALL=C sort; }
expected_q09() { find tree/scripts -type f -name '*.sh' -exec basename {} \; | LC_ALL=C sort; }
expected_q10() { locate -d locate.db '*.conf' | LC_ALL=C sort; }
expected_q11() { printf '%s/tree/incoming/new-note.txt\n' "$lab_dir"; }
expected_challenge() { printf 'tree/tmp/cache.tmp\n'; }

printf 'Checking find and locate reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 8 'Q1: case-sensitive .conf files are found' check_report reports/q01.txt expected_q01
check 8 'Q2: case-insensitive .md files are found' check_report reports/q02.txt expected_q02
check 8 'Q3: directories are selected' check_report reports/q03.txt expected_q03
check 8 'Q4: files larger than 50 bytes are selected' check_report reports/q04.txt expected_q04
check 8 'Q5: files older than seven days are selected' check_report reports/q05.txt expected_q05
check 8 'Q6: exact mode 640 is matched' check_report reports/q06.txt expected_q06
check 8 'Q7: grouped name alternatives are selected' check_report reports/q07.txt expected_q07
check 8 'Q8: empty files are selected' check_report reports/q08.txt expected_q08
check 8 'Q9: -exec prints shell-script basenames' check_report reports/q09.txt expected_q09
check 8 'Q10: locate searches the lab database' check_report reports/q10.txt expected_q10
check 8 'Q11: refreshed locate database includes the new file' check_report reports/q11.txt expected_q11
check 12 'Challenge: preview is saved and only the target is deleted' check_report reports/challenge.txt expected_challenge && [[ ! -e tree/tmp/cache.tmp ]]

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1