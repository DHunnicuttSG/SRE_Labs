# Instructor Notes

## Learning objectives

Students use `sed` substitution flags, case-insensitive matching, the `-n` and `p` combination, recursive dry-run substitutions, in-place edits, pattern and line addressing, the `=`, `N`, `i`, `a`, and `y` commands, GNU case conversion, and pipelines.

## Environment

The lab runs as the non-root `student` account in Ubuntu 24.04 and uses GNU `sed`. The fixture dataset is copied into `~/sed_practice`; no host directories are mounted into Docker. A local Bash setup is also provided.

## Answer key

Run these from `~/sed_practice`:

```sh
sed 's/ERROR/ERR/' log.txt | tee reports/q01.txt
sed 's/INFO/INFORMATION/g' log.txt | tee reports/q02.txt
sed 's/warning/WARN/Ig' system.log | tee reports/q03.txt
sed -n 's/failed/FAIL/p' report.txt | tee reports/q04.txt
grep -rl 'port=8080' etc | xargs sed -n 's/port=8080/port=80/p' | tee reports/q05.txt
sed -i 's/^host=.*/host=127.0.0.1/' etc/app/config.conf
cat etc/app/config.conf | tee reports/q06.txt
sed '/DEBUG/d' app.log | tee reports/q07.txt
sed 's/^ERROR/[ERROR] &/' server.log | tee reports/q08.txt
sed = animals.txt | sed 'N;s/\n/\t/' | tee reports/q09.txt
sed -n 's/^\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p' access.log | tee reports/q10.txt
sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\1\/\2\/\3/g' data.txt | tee reports/q11.txt
sed -n '/critical/I{s/.*/\U&/p}' kernel.log | tee reports/q12.txt
sed '1i\# Log Start' log.txt | tee reports/q13.txt
sed '$a\# Log End' log.txt | tee reports/q14.txt
sed 'y/cb/ba/' animals.txt | tee reports/q15.txt
nl -ba log.txt | sed '/DEBUG/d;s/ERROR/ERR/' | tee reports/challenge.txt
```

The fixture files are the matching filenames from the Grep Lab dataset, whose sample content differs from the linked worksheet's original dataset. The grader derives expected report output from the local fixtures. The date expression checks textual shape, not calendar validity; the address expression extracts IPv4-shaped text without validating octet ranges.

## Grading

The grader compares saved reports with expected output generated from the fixture dataset. Each worksheet item is worth 6 points and the challenge is worth 10, for 100 points total. Q6 also checks the in-place config file. The grader validates results, not command history; observe or ask students to demonstrate their commands if command-use evidence is required. The grader and setup files are visible teaching materials, not a tamper-resistant assessment system.