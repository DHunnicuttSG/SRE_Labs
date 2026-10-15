# Instructor Notes

## Learning objectives

Students traverse a directory tree with `find`; match names, types, size, modification age, permissions, and emptiness; group `-and`/`-or` expressions; use `-exec`; preview and safely delete known fixture files; and distinguish live traversal from a `locate` database.

## Environment

The Docker image runs as the unprivileged `student` account and installs GNU findutils. Setup copies fixtures into `~/find_practice` and builds `locate.db` from only that fixture tree. No host directories are mounted. Local setup expects GNU findutils.

The setup script makes `tree/logs/archive/old.log` older than seven days and sets `tree/config/secret.conf` to mode `640`. The challenge deletes only `tree/tmp/cache.tmp` after students preview the result. The database exercise creates a new file and then explicitly refreshes the local database.

## Answer key

From `~/find_practice`:

```sh
find tree -type f -name '*.conf' -print | LC_ALL=C sort | tee reports/q01.txt
find tree -type f -iname '*.md' -print | LC_ALL=C sort | tee reports/q02.txt
find tree -type d -print | LC_ALL=C sort | tee reports/q03.txt
find tree -type f -size +50c -print | LC_ALL=C sort | tee reports/q04.txt
find tree -type f -mtime +7 -print | LC_ALL=C sort | tee reports/q05.txt
find tree -type f -perm 0640 -print | LC_ALL=C sort | tee reports/q06.txt
find tree -type f \( -name '*.conf' -o -name '*.log' \) -print | LC_ALL=C sort | tee reports/q07.txt
find tree -type f -empty -print | LC_ALL=C sort | tee reports/q08.txt
find tree/scripts -type f -name '*.sh' -exec basename {} \; | LC_ALL=C sort | tee reports/q09.txt
locate -d locate.db '*.conf' | LC_ALL=C sort | tee reports/q10.txt

mkdir -p tree/incoming
printf 'new note\n' > tree/incoming/new-note.txt
locate -d locate.db 'new-note.txt'
updatedb --localpaths="$PWD/tree" --output="$PWD/locate.db"
locate -d locate.db 'new-note.txt' | tee reports/q11.txt

find tree/tmp -type f -name '*.tmp' -print | tee reports/challenge.txt
cat reports/challenge.txt
find tree/tmp -type f -name '*.tmp' -delete
```

## Grading

Each of eleven reports is worth 8 points; the challenge is worth 12, for 100 total. The grader evaluates expected output from the fixed fixture tree and verifies the challenge file was removed. Reports establish the result, not the command history. Ask students to demonstrate the grouped expression, the locate refresh, and the preview-before-delete workflow when command-use evidence is needed.

`-mtime` uses whole-day age buckets; `+7` excludes files whose rounded age is seven or fewer. `-perm 0640` requests an exact match, while a leading `-` or `/` changes GNU find's permission matching semantics. Parentheses are escaped or quoted to keep the shell from interpreting them. `locate` searches its database and may return stale paths; `find` walks the current tree. Keep the custom index restricted to the lab fixture so the exercise does not depend on or expose unrelated system paths.