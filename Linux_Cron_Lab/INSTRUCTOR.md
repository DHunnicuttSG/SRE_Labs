# Instructor Notes

## Learning objectives

Students read the five cron schedule fields, install per-user jobs, distinguish the one-minute schedule from a daily schedule, use absolute paths, redirect stdout and stderr to persistent files, verify daemon status, and validate real job output. They also practice reviewing/removing only their own lab crontab entries.

## Environment and safety

The Docker image installs cron and runs the daemon as root only inside the disposable container. Student jobs run as the unprivileged `student` account. No host directories are mounted. The local setup only copies files to `~/cron_practice`; it does not modify the user's crontab. The EC2 path is intended for an existing disposable or training Linux instance, and only user-level test jobs are scheduled.

The heartbeat script prints a UTC timestamp. The daily health script reports root filesystem usage. Both scripts use absolute command paths; crontab entries redirect stdout and stderr into lab-local logs. Do not require students to wait until 02:00: the daily script is run manually for verification.

## Answer key

In `~/cron_practice`, replace `/home/student` below with the absolute home path printed on the student's Linux host:

```cron
* * * * * /home/student/cron_practice/scripts/heartbeat.sh >> /home/student/cron_practice/logs/heartbeat.log 2>&1
0 2 * * * /home/student/cron_practice/scripts/daily_health.sh >> /home/student/cron_practice/logs/daily-health.log 2>&1
15 3 * * 1 /home/student/cron_practice/scripts/daily_health.sh >> /home/student/cron_practice/logs/weekly-health.log 2>&1
```

Save the first and second lines individually to `reports/q01.txt` and `reports/q02.txt`. Save the first two sorted lines to `reports/q03.txt`, the service confirmation to `reports/q04.txt`, one manual heartbeat line to `reports/q05.txt`, a positive heartbeat count to `reports/q06.txt`, one manual health line to `reports/q07.txt`, and the third cron line to `reports/challenge.txt`.

## Grading

Each of seven reports is worth 10 points; the weekly challenge is worth 30, for 100 points. The grader checks the installed user's crontab, verifies cron/crond is running, validates timestamped script output, and checks that the one-minute job has run. It checks report content and configuration, not how students edited the crontab.

## Troubleshooting

- Confirm the job is installed under the expected account with `crontab -l`; root's crontab is not the student's crontab.
- Check the service appropriate to the OS: `cron` on Ubuntu/Debian and typically `crond` on Amazon Linux/RHEL-family systems.
- Review the lab's output files first. Cron may send command output to local mail when not redirected; these exercises redirect both output streams to files.
- Check script executable bits, line endings, exact absolute paths, the host timezone, and whether the host was powered on at the scheduled minute.
- Keep the test schedule short-lived. Remove only the lab's lines and preserve unrelated crontab entries.