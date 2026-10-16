# Instructor Notes

## Learning objectives

Students define and inspect Bash aliases, load a shell configuration file with `source`, distinguish fixed aliases from parameterized functions, validate function arguments, quote user-provided values, and practice safe log triage.

## Environment

The Docker lab runs as the unprivileged `student` account in Ubuntu 24.04. A local Bash setup is also provided. Both copy the same fixture logs into `~/alias_practice`; neither modifies the user's Bash startup files. The graded commands are read-only apart from creating the exercise directory and reports.

## Answer key

Put the following in `~/alias_practice/aliases.sh`:

```bash
alias ll='ls -alF --color=auto'
alias errors='grep --color=never -i -n -C 1 -- "error"'
alias t100='tail -n 100'
alias dfh='df -h'

logfind() {
  if (( $# < 2 )); then
    printf 'Usage: logfind PATTERN FILE...\n' >&2
    return 2
  fi

  grep --color=never -i -n -C 1 -- "$1" "${@:2}"
}

mkcd() {
  if (( $# != 1 )); then
    printf 'Usage: mkcd DIRECTORY\n' >&2
    return 2
  fi

  mkdir -p -- "$1" && cd -- "$1"
}
```

Then source the file and create the reports:

```bash
cd ~/alias_practice
source aliases.sh
errors logs/app.log | tee reports/q01.txt
logfind database logs/app.log logs/api.log | tee reports/q02.txt
mkcd work/incident-notes
pwd | tee ~/alias_practice/reports/q03.txt
logfind timeout logs/api.log | tee ~/alias_practice/reports/challenge.txt
```

## Grading

The grader awards 100 points and exits successfully only at a full score. It checks alias definitions and output, verifies function definitions and behavior including invalid-argument status, and compares reports to fixture-derived expected output. As with other command labs, it validates results, not command history; ask students to demonstrate usage if command-use evidence is needed. Definitions and grader files are visible teaching materials, not a tamper-resistant assessment system.