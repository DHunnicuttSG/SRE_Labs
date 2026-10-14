# Instructor Notes

## Learning objectives

Students select fields and records, use `NR`, `NF`, `BEGIN`, and `END`, change field separators, apply regular expressions, count and sum values, format output with `printf`, and combine filtering, substitution, and pipelines. GNU awk extensions are used for case-insensitive matching, capture-group replacement, and sorted array traversal.

## Environment

The lab runs as the non-root `student` account in Ubuntu 24.04 with GNU awk installed and selected as the `awk` command. A local Bash setup is also provided and requires `gawk` on `PATH`. The fixture dataset is copied into `~/awk_practice`; no host directories are mounted into Docker.

## Answer key

From `~/awk_practice`:

```sh
awk '/ERROR/ {print NR ":" $0}' log.txt | tee reports/q01.txt
awk '/ERROR/ {count++} END {print count+0}' log.txt | tee reports/q02.txt
gawk 'BEGIN {IGNORECASE=1} /warning/ {count++} END {print count+0}' system.log | tee reports/q03.txt
awk '{print $1}' access.log | tee reports/q04.txt
awk '{sum += $NF} END {print sum+0}' access.log | tee reports/q05.txt
awk -F '"' '{split($3, fields, " "); print fields[1], $2}' access.log | tee reports/q06.txt
awk '{gsub(/ERROR/, "ERR"); print}' log.txt | tee reports/q07.txt
awk '!/DEBUG/' app.log | tee reports/q08.txt
awk '/^ERROR/' server.log | tee reports/q09.txt
awk 'match($0, /([0-9]{1,3}\.){3}[0-9]{1,3}/) {print substr($0, RSTART, RLENGTH)}' access.log | tee reports/q10.txt
gawk '{print gensub(/([0-9]{4})-([0-9]{2})-([0-9]{2})/, "\\1/\\2/\\3", "g")}' data.txt | tee reports/q11.txt
gawk 'tolower($0) ~ /critical/ {print toupper($0)}' kernel.log | tee reports/q12.txt
awk 'BEGIN {print "# Log Start"} {print} END {print "# Log End"}' log.txt | tee reports/q13.txt
awk '{printf "%5d\t%s\n", NR, $0}' animals.txt | tee reports/q14.txt
gawk '{count[$3]++} END {n=asorti(count, keys); for (i=1; i<=n; i++) printf "%s %d\n", keys[i], count[keys[i]]}' log.txt | tee reports/q15.txt
awk '!/DEBUG/ {gsub(/ERROR/, "ERR"); printf "%5d\t%s\n", NR, $0}' log.txt | head -n 10 | tee reports/challenge.txt
```

The supplied `log.txt` has a date in field 1, a time in field 2, and the log level in field 3. Therefore task 15 counts `$3`, rather than `$1` as in the worksheet's example. Tasks 3, 11, and 15 use GNU awk extensions. The date substitution changes strings with the requested shape; it does not validate calendar dates.

## Grading

The grader compares each saved report with expected output generated from the fixture dataset. It awards 100 points and exits successfully only at a full score. This validates results, not command history; observe or ask students to demonstrate the awk constructs if command-use evidence is required. The grader and setup files are visible teaching materials, not a tamper-resistant assessment system.