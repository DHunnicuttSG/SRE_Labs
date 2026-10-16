#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/links_practice"
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

expected_q01() {
  local original_inode linked_inode original_count linked_count
  original_inode="$(stat -c '%i' data/service.log 2>/dev/null)" || return 1
  linked_inode="$(stat -c '%i' evidence/service-hard.log 2>/dev/null)" || return 1
  original_count="$(stat -c '%h' data/service.log 2>/dev/null)" || return 1
  linked_count="$(stat -c '%h' evidence/service-hard.log 2>/dev/null)" || return 1
  [[ "$original_inode" == "$linked_inode" && "$original_count" == 2 && "$linked_count" == 2 ]] || return 1
  stat -c '%i %h %n' data/service.log evidence/service-hard.log | sort -k3,3
}

expected_q02() {
  [[ "$(stat -c '%i' data/service.log 2>/dev/null)" == "$(stat -c '%i' evidence/service-hard.log 2>/dev/null)" ]] || return 1
  [[ "$(stat -c '%h' data/service.log 2>/dev/null)" == 2 ]] || return 1
  stat -c 'inode=%i links=%h' data/service.log
}

expected_q03() {
  printf '2026-10-16T09:00:00Z INFO api started\n2026-10-16T09:05:00Z ERROR upstream timeout\n2026-10-16T09:15:00Z WARN retry scheduled\n'
}

expected_q04() {
  [[ "$(stat -c '%i' data/service.log 2>/dev/null)" == "$(stat -c '%i' evidence/service-hard.log 2>/dev/null)" ]] || return 1
  find data evidence -type f -samefile evidence/service-hard.log -print | LC_ALL=C sort
}

expected_q05() {
  [[ ! -e data/service.log && "$(stat -c '%h' evidence/service-hard.log 2>/dev/null)" == 1 ]] || return 1
  printf 'remaining hard links=1\n'
  cat evidence/service-hard.log
}

expected_q06() {
  [[ -L links/config-current.conf ]] || return 1
  [[ "$(readlink links/config-current.conf)" == '../releases/v1/app.conf' ]] || return 1
  printf '../releases/v1/app.conf\n'
}

expected_q07() {
  [[ "$(readlink links/config-current.conf 2>/dev/null)" == '../releases/v1/app.conf' ]] || return 1
  cat releases/v1/app.conf
}

expected_q08() {
  [[ ! -e links/config-next.conf && ! -L links/config-next.conf ]] || return 1
  [[ "$(readlink links/config-current.conf 2>/dev/null)" == '../releases/v2/app.conf' ]] || return 1
  printf 'target=../releases/v2/app.conf\n'
  cat releases/v2/app.conf
}

expected_q09() {
  [[ -L links/next.conf && ! -e links/next.conf ]] || return 1
  printf 'symlink exists; target missing\n'
}

expected_q10() {
  [[ -f releases/v3/app.conf && "$(readlink links/next.conf 2>/dev/null)" == '../releases/v3/app.conf' ]] || return 1
  printf 'release=v3\nservice=payments\n'
}

expected_challenge() {
  [[ ! -L links/config-current.conf && ! -e links/config-current.conf && -f releases/v2/app.conf ]] || return 1
  printf 'link removed; target retained\n'
}

printf 'Checking hard/soft link reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 8 'Q1: hard-link names share an inode and link count' check_report reports/q01.txt expected_q01
check 8 'Q2: inode identity and link count are confirmed' check_report reports/q02.txt expected_q02
check 8 'Q3: writing through a hard link changes shared data' check_report reports/q03.txt expected_q03
check 8 'Q4: find locates both names for the inode' check_report reports/q04.txt expected_q04
check 8 'Q5: data survives removal of one hard-link name' check_report reports/q05.txt expected_q05
check 8 'Q6: relative symlink stores the intended target' check_report reports/q06.txt expected_q06
check 8 'Q7: symlink resolves to the v1 configuration' check_report reports/q07.txt expected_q07
check 8 'Q8: release symlink switches to v2' check_report reports/q08.txt expected_q08
check 8 'Q9: dangling symlink is identified correctly' check_report reports/q09.txt expected_q09
check 8 'Q10: creating the target repairs the symlink' check_report reports/q10.txt expected_q10
check 20 'Challenge: symlink is removed without deleting its target' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1