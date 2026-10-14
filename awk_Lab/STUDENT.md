# Student Exercise: Process Text with awk

## Goal

Practice selecting fields, matching patterns, counting and summing values, changing output, using `printf`, and combining awk operations. Work in `~/awk_practice`; save each result in `reports/` so the grader can check it.

Start in the dataset directory and inspect its files:

```sh
cd ~/awk_practice
ls
```

Save a command's output while displaying it with `| tee reports/name.txt`. For example:

```sh
awk '/ERROR/ {print NR ":" $0}' log.txt | tee reports/q01.txt
```

In awk, `$0` is the entire line, `$1`, `$2`, and so on are fields, `NR` is the current input line number, and `NF` is the number of fields. Use `-F` to choose a field separator. `BEGIN` runs before input and `END` runs after it. GNU awk is installed in the Docker lab and required for tasks that use `IGNORECASE`, `gensub`, or `asorti`.

## Easy

1. Print each line in `log.txt` containing `ERROR`, prefixed with its line number as `number:line`. Save to `reports/q01.txt`.
2. Count lines containing `ERROR` in `log.txt`; print `0` if there are no matches. Save to `reports/q02.txt`.
3. Count occurrences of `warning` in `system.log`, ignoring case. Save the count to `reports/q03.txt`.
4. Print the first whitespace-separated field (client IP) from each line of `access.log`. Save to `reports/q04.txt`.

## Intermediate

5. Sum the response sizes in the last column of `access.log`. Save the total to `reports/q05.txt`.
6. Print the HTTP status code followed by the request line from each `access.log` entry. Save to `reports/q06.txt`.
7. Replace every `ERROR` with `ERR` in the output from `log.txt`. Save to `reports/q07.txt`.
8. Print `app.log` without lines containing `DEBUG`. Save to `reports/q08.txt`.
9. Print lines in `server.log` that start with `ERROR`. Save to `reports/q09.txt`.

## Advanced

10. Extract and print the IPv4 address from each line of `access.log` using `match()`. Save to `reports/q10.txt`.
11. In `data.txt`, change dates in `YYYY-MM-DD` form to `YYYY/MM/DD`. Save the full modified file to `reports/q11.txt`.
12. Print only lines containing `critical` (case-insensitive) from `kernel.log`, with each matching line uppercased. Save to `reports/q12.txt`.
13. Print `log.txt` with `# Log Start` before it and `# Log End` after it. Save to `reports/q13.txt`.
14. Print `animals.txt` with right-aligned line numbers in a five-character field, followed by a tab and the original line. Save to `reports/q14.txt`.
15. Count log levels in `log.txt` and print the levels in sorted order, one level and count per line. Save to `reports/q15.txt`.

## Challenge

From `log.txt`, remove lines containing `DEBUG`, replace `ERROR` with `ERR` in the remaining lines, prefix each with its original line number in a five-character field, and show only the first ten results. Save to `reports/challenge.txt`.

## Submit

Run the grader from any directory:

```sh
bash /opt/awk-lab/grade.sh
```

For a local Bash run, use `bash /path/to/awk_Lab/grade.sh`. The grader checks report contents; it cannot prove which commands you typed. Be prepared to explain your patterns, field references, and GNU awk features.