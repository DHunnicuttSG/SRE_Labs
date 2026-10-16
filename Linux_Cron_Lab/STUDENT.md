# Student Exercise: Linux Cron Jobs

## Goal

Install a one-minute job and a daily job in your own crontab, use absolute paths and explicit output redirection, verify cron is running, and confirm that scheduled jobs produce logs. Work in `~/cron_practice`.

Start by checking your home directory and inspecting the provided scripts:

```sh
cd ~/cron_practice
printf '%s\n' "$HOME"
ls -l scripts
```

Use the full path printed by `printf` in every crontab command. Cron does not expand `~` in command paths and runs with a minimal environment. Do not add `sudo` to the job commands.

## Easy

1. Install a user crontab entry that runs `scripts/heartbeat.sh` every minute and appends both standard output and errors to `logs/heartbeat.log`. Use absolute paths. Save the exact installed entry to `reports/q01.txt`.
2. Add a second entry that runs `scripts/daily_health.sh` at 02:00 every day and appends output and errors to `logs/daily-health.log`. Save the exact installed entry to `reports/q02.txt`.
3. List the two lab entries from `crontab -l`, sort them, and save them to `reports/q03.txt`.
4. Confirm the cron daemon is running. Use `pgrep` for `cron` or `crond`; save exactly `cron running` to `reports/q04.txt` when one is active.
5. Run `scripts/heartbeat.sh` manually and save its output to `reports/q05.txt`. It should include a UTC timestamp.

## Advanced

6. Wait one or two minutes. Count `HEARTBEAT` lines in `logs/heartbeat.log` and save the count to `reports/q06.txt`.
7. Run `scripts/daily_health.sh` manually and save its output to `reports/q07.txt`. This verifies the script independently of its 02:00 schedule.

## Challenge

Add a weekly entry that runs `scripts/daily_health.sh` at 03:15 every Monday, with output and errors appended to `logs/weekly-health.log`. Save that exact entry to `reports/challenge.txt`. Confirm all three entries remain in your crontab.

Run the grader with:

```sh
bash /opt/linux-cron-lab/grade.sh
```

For a local Linux/EC2 run, use `bash /path/to/Linux_Cron_Lab/grade.sh`. After grading, remove only this lab's entries with `crontab -e`; do not use `crontab -r`, which removes the entire user crontab.

## Production Support Notes

- Cron uses five schedule fields: minute, hour, day of month, month, and day of week. `* * * * *` runs each minute; `0 2 * * *` runs daily at 02:00 in the host's configured timezone.
- Cron has a limited environment. Set needed variables explicitly, use absolute paths for scripts and commands, and set the working directory inside the script if it depends on one.
- Redirect both streams with `>> logfile 2>&1` so output and failures are retained. Use append redirection for recurring job logs; `>` truncates the prior run's output.
- Check the correct service name for the distribution (`cron` or `crond`), inspect the user's installed schedule with `crontab -l`, and inspect the job's own log. Cron's service log location varies by distribution.
- A schedule does not guarantee success. Check executable permissions, ownership, absolute paths, timezone, disk space for logs, and whether the instance was running at the scheduled time. Standard cron generally does not replay runs missed while a host is stopped.
- Keep jobs idempotent and bounded. Prevent overlapping runs when a task can exceed its interval, and never put passwords or other secrets directly in a crontab line.