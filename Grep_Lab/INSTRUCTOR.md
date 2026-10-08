# Instructor Notes

## Learning objectives

Students search fixed strings and regular expressions; use `-i`, `-v`, `-n`, `-c`, `-r`, `-w`, `-E`, `-o`, `-C`, and `-l`; filter recursive results by filename; and combine commands with pipes.

## Environment

The lab runs as the non-root `student` account in Ubuntu 24.04. The fixture dataset is copied into `~/grep_practice`; no host directories are mounted into Docker. A local Bash setup is also provided.

## Answer key

From `~/grep_practice`:

```sh
grep -F 'error' log.txt | tee reports/q01.txt
grep -i 'warning' system.log | tee reports/q02.txt
grep -ic 'success' output.txt | tee reports/q03.txt
grep -n 'failed' report.txt | tee reports/q04.txt
grep -r --include='*.py' 'TODO' projects | tee reports/q05.txt
grep -w 'cat' animals.txt | tee reports/q06.txt
grep -v 'DEBUG' app.log | tee reports/q07.txt
grep '^ERROR' server.log | tee reports/q08.txt
grep -Ei 'error|fail' system.log | tee reports/q09.txt
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' access.log | tee reports/q10.txt
grep -i -C 3 'critical' kernel.log | tee reports/q11.txt
grep -rlF -- 'port=8080' etc | tee reports/q12.txt
grep -Eo '\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b' data.txt | tee reports/q13.txt
grep -n 'ERROR' log.txt | grep -v 'DEBUG' | head -n 10 | tee reports/challenge.txt
```

`grep -c` counts matching lines, not repeated occurrences within the same line. The fixture has one `success` token per matching line. The date expression checks the requested textual shape, not whether a calendar date is valid.

## Grading

The grader compares each saved report with the expected output generated from the fixture dataset. It awards 100 points and exits successfully only at a full score. This validates results, not command history; observe or ask students to demonstrate the options and pipeline if command-use evidence is required. The grader and setup files are visible teaching materials, not a tamper-resistant assessment system.