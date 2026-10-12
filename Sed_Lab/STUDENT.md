# Student Exercise: Transform Text with sed

## Goal

Practice substitutions, flags, pattern and line addressing, in-place editing, insertion, appending, transliteration, and pipelines. Work in `~/sed_practice`; save each result in `reports/` so the grader can check it.

Start in the dataset directory and inspect its files:

```sh
cd ~/sed_practice
ls
```

Save a command's output while displaying it with `| tee reports/name.txt`. For example:

```sh
sed 's/ERROR/ERR/' log.txt | tee reports/q01.txt
```

## Easy

1. Replace the first `ERROR` with `ERR` on each line of `log.txt`. Save to `reports/q01.txt`.
2. Replace every `INFO` with `INFORMATION` in `log.txt`. Save to `reports/q02.txt`.
3. Replace `warning` with `WARN`, ignoring case, in `system.log`. Save to `reports/q03.txt`.
4. Print only lines in `report.txt` where `failed` was replaced with `FAIL`. Save to `reports/q04.txt`.

## Intermediate

5. Preview replacing `port=8080` with `port=80` in files under `etc`. Do not edit files. Save the changed lines to `reports/q05.txt`.
6. Edit `etc/app/config.conf` in place so its `host` setting is `127.0.0.1`. Save the resulting file to `reports/q06.txt`.
7. Delete lines containing `DEBUG` from `app.log` in the output only. Save to `reports/q07.txt`.
8. Prefix `[ERROR] ` to lines starting with `ERROR` in `server.log`. Save to `reports/q08.txt`.
9. Number the lines in `animals.txt` as `line_number<TAB>content`. Save to `reports/q09.txt`.

## Advanced

10. Extract the first IPv4-shaped address from each line of `access.log`. Save to `reports/q10.txt`.
11. Change dates in `YYYY-MM-DD` form to `YYYY/MM/DD` in `data.txt`. Save to `reports/q11.txt`.
12. Print lines containing `critical`, ignoring case, and uppercase each matching line in `kernel.log`. Save to `reports/q12.txt`.
13. Insert `# Log Start` before the first line of `log.txt`, without editing the file. Save to `reports/q13.txt`.
14. Append `# Log End` after the last line of `log.txt`, without editing the file. Save to `reports/q14.txt`.
15. Transliterate `c` to `b` and `b` to `a` in `animals.txt`. Save to `reports/q15.txt`.

## Challenge

For `log.txt`, delete lines containing `DEBUG`, prefix line numbers, and change `ERROR` to `ERR`. Use a pipeline and save the result to `reports/challenge.txt`.

## Submit

Run the grader:

```sh
bash /opt/sed-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Sed_Lab/grade.sh`. The grader checks report contents and the in-place configuration edit; it cannot prove which commands you typed. Be prepared to explain the commands and expressions you used.