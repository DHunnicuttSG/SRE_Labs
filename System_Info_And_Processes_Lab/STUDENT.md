# Student Exercise: System Info and Processes

## Goal

Collect a short system baseline, inspect a controlled background process, and stop it cleanly. All tasks run as the unprivileged `student` user; no system configuration changes are needed.

## 1. Collect system information

Create a report directory in the exercise workspace:

```sh
cd ~/system_info_lab
mkdir -p reports
```

Collect and save the following command output:

- `uname -a` and `cat /etc/os-release` in `reports/system.txt`.
- `hostname` in `reports/hostname.txt`.
- `uptime` in `reports/uptime.txt`.
- `free -h` in `reports/memory.txt`.
- `df -h /` in `reports/disk.txt`.
- `vmstat 1 3` in `reports/vmstat.txt`.

Use `tee` to display output and save it at the same time. For multiple commands in one file, group them:

```sh
{ uname -a; cat /etc/os-release; } | tee reports/system.txt
```

## 2. Inspect a background process

Start a harmless process that sleeps without using CPU:

```sh
sleep 600 &
worker_pid=$!
printf '%s\n' "$worker_pid" | tee reports/worker.pid
```

Use `jobs -l` to inspect the shell job and save it to `reports/jobs.txt`. Use `ps -p "$worker_pid" -o pid,ppid,stat,%cpu,%mem,comm` and save the output to `reports/process.txt`. You can also inspect the system interactively with `top`; press `q` to exit.

## 3. Stop the process cleanly

Send `SIGTERM` and wait for the process to exit:

```sh
kill -TERM "$worker_pid"
wait "$worker_pid"
printf 'Exit status: %s\n' "$?" | tee reports/stop-status.txt
```

In Bash, exit status `143` means the process ended after receiving `SIGTERM` (signal 15). Do not use `kill -9` for this exercise.

## 4. Submit

Run the grader from any directory:

```sh
bash /opt/system-info-and-processes-lab/grade.sh
```

The grader checks saved command output; it cannot prove which commands you typed. Be prepared to explain what the load, memory, process-state, and `vmstat` columns show.