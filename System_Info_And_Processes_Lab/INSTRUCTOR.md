# Instructor Notes

## Learning objectives

Students collect basic OS, hostname, uptime, memory, disk, and virtual-memory statistics; inspect a background process with shell job control and `ps`; and terminate it gracefully with `SIGTERM`.

## Answer key

From the student's shell:

```sh
cd ~/system_info_lab
mkdir -p reports
{ uname -a; cat /etc/os-release; } | tee reports/system.txt
hostname | tee reports/hostname.txt
uptime | tee reports/uptime.txt
free -h | tee reports/memory.txt
df -h / | tee reports/disk.txt
vmstat 1 3 | tee reports/vmstat.txt
sleep 600 &
worker_pid=$!
printf '%s\n' "$worker_pid" | tee reports/worker.pid
jobs -l > reports/jobs.txt
cat reports/jobs.txt
ps -p "$worker_pid" -o pid,ppid,stat,%cpu,%mem,comm | tee reports/process.txt
kill -TERM "$worker_pid"
wait "$worker_pid"
printf 'Exit status: %s\n' "$?" | tee reports/stop-status.txt
bash /opt/system-info-and-processes-lab/grade.sh
```

## Grading

The grader awards 100 points for captured output identifying Linux, hostname, load average, memory, root filesystem, `vmstat` memory columns, the background job, process details, and a `SIGTERM` wait status. The reports show results but do not prove the student entered each command.

This container does not run systemd. The lab intentionally excludes `systemctl`, `journalctl`, `iostat`, and `strace`; the last may also be blocked by container ptrace restrictions.