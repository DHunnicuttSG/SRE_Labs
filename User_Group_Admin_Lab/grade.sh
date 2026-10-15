#!/usr/bin/env bash
set -uo pipefail

lab_dir="/opt/user_group_admin_practice"
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

expected_q01() { printf 'project_team\n'; }
expected_q02() { printf 'project_team\n'; }
expected_q03() { printf 'lab_alice\nlab_bob\n'; }
expected_q04() { printf 'project_team\n'; }
expected_q05() { printf '770 drwxrwx---\n'; }
expected_q06() { printf '2770 drwxrws---\n'; }
expected_q07() { printf 'lab_alice project_team\n'; }
expected_q08() { printf '664 -rw-rw-r--\n'; }
expected_q09() { printf 'not a member\n'; }
expected_q10() { printf '640 -rw-r-----\n'; }
expected_q11() { printf 'project_team 660\n'; }
expected_q12() { printf 'read-write\n'; }
expected_challenge() {
  printf 'README.txt:project_team\ncreated_by_alice.txt:project_team\ngroup_writable.txt:project_team\n'
}

printf 'Checking user/group administration reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 7 'Q1: project_team group exists' check_report reports/q01.txt expected_q01
check 7 'Q2: lab_alice is a supplementary group member' check_report reports/q02.txt expected_q02
check 7 'Q3: both team users are listed as group members' check_report reports/q03.txt expected_q03
check 7 'Q4: shared directory has project_team ownership' check_report reports/q04.txt expected_q04
check 7 'Q5: shared directory has mode 770' check_report reports/q05.txt expected_q05
check 7 'Q6: setgid is enabled on the shared directory' check_report reports/q06.txt expected_q06
check 7 'Q7: Alice-created file inherits team group ownership' check_report reports/q07.txt expected_q07
check 7 'Q8: umask 002 creates a group-writable file' check_report reports/q08.txt expected_q08
check 7 'Q9: auditor is not a team member' check_report reports/q09.txt expected_q09
check 7 'Q10: private budget file has mode 640' check_report reports/q10.txt expected_q10
check 7 'Q11: symbolic permissions grant team access only' check_report reports/q11.txt expected_q11
check 7 'Q12: Alice can read and write the team file' check_report reports/q12.txt expected_q12
check 16 'Challenge: all shared project files use project_team' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1