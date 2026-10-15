# Instructor Notes

## Learning objectives

Students distinguish overwrite (`>`) from append (`>>`), redirect standard input with `<`, provide input using here-documents (`<<`) and here-strings (`<<<`), and compose commands with pipelines (`|`). Exercises use deterministic fixture data and save outputs for exact comparison.

## Environment

The lab runs as the non-root `student` account in Ubuntu 24.04. The fixture dataset is copied into `~/redirection_practice`; no host directories are mounted into Docker. A local Bash setup is also provided.

## Answer key

From `~/redirection_practice`:

```sh
echo 'Hello Linux' > hello.txt
cat hello.txt | tee reports/q01.txt
echo 'Learning redirection' >> hello.txt
cat hello.txt | tee reports/q02.txt
sort < names.txt | tee reports/q03.txt
cat <<'EOF' | tee reports/q04.txt
North
South
West
EOF
wc -w <<< 'quick brown fox' | tee reports/q05.txt
ls services | grep -c '\.conf$' | tee reports/q06.txt
grep 'ERROR' events.log > errors.txt
cat errors.txt | tee reports/q07.txt
echo 'task completed' >> activity.log
cat activity.log | tee reports/q08.txt
wc -l < names.txt | tee reports/q09.txt
cat events.log | grep -E '^(ERROR|WARN)' | sort | tee reports/q10.txt
grep 'WARN' <<'EOF' | tee reports/q11.txt
INFO service started
WARN retrying database
ERROR connection timeout
EOF
cat names.txt | grep -E '^(M|O)' | tr '[:lower:]' '[:upper:]' | tee reports/q12.txt
grep -h '^port=' services/*.conf | sort -t= -k2,2n | tee reports/q13.txt
ls services | grep -c '\.conf$' > reports/challenge.txt
```

`>` truncates or creates its destination; `>>` appends. `<<<` is a Bash here-string, and `<<` introduces a here-document. `>>>` is not a standard Bash redirection operator and should not be taught as one.

## Grading

The grader compares each saved report with expected output generated from the fixture dataset. It awards 100 points and exits successfully only at a full score. This validates results, not command history; ask students to demonstrate the redirection and pipeline syntax if command-use evidence is required. The grader and setup files are visible teaching materials, not a tamper-resistant assessment system.