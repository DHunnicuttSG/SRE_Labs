# Instructor Notes

## Learning objectives

Students use `systemctl` to discover failed units and distinguish service runtime state from boot enablement; inspect status, properties, unit definitions, and dependencies; and use `journalctl` to investigate unit, severity, boot, time-window, and kernel events and export scoped logs.

## Environment

The lab runs as the non-root `student` account in Ubuntu 24.04. Fixture data is copied to `~/systemctl_practice`; no host directories are mounted into Docker. The `systemctl` and `journalctl` executables are read-only shell shims earlier on the lab user's `PATH`. They query only the fixture files and do not invoke the host's systemd manager. Mutations and live-follow mode are intentionally unsupported.

The scenario is a synthetic `payments-api.service` failure after a database connection timeout. The unit is enabled but failed. Current-boot logs show the service failure and recovery-loop messages; the previous boot and kernel fixtures provide comparison evidence.

## Answer key

Run from `~/systemctl_practice` after sourcing `lab-env.sh`:

```sh
systemctl --failed | tee reports/q01.txt
systemctl status payments-api.service | tee reports/q02.txt
systemctl is-active payments-api.service | tee reports/q03.txt
systemctl is-enabled payments-api.service | tee reports/q04.txt
systemctl show payments-api.service -p ActiveState -p SubState -p Result -p ExecMainStatus -p FragmentPath | tee reports/q05.txt
systemctl cat payments-api.service | tee reports/q06.txt
systemctl list-dependencies payments-api.service | tee reports/q07.txt
journalctl -u payments-api.service -n 8 | tee reports/q08.txt
journalctl -u payments-api.service -p warning | tee reports/q09.txt
journalctl -u payments-api.service -b -1 | tee reports/q10.txt
journalctl --list-boots | tee reports/q11.txt
journalctl -k -p warning | tee reports/q12.txt
journalctl -u payments-api.service --since '2026-10-16 09:30:00' | tee reports/q13.txt
journalctl -u payments-api.service > reports/payments-api.log
wc -l < reports/payments-api.log | tr -d ' ' | tee reports/q14.txt
journalctl -u payments-api.service -b -1 -p warning -n 2 | tee reports/challenge.txt
```

## Grading

The grader checks fourteen report files and one challenge report against fixture-backed expected output. Each question, including the challenge, is worth 10 points, for 150 total. It validates resulting output, not command history. Ask students to explain why the service can be enabled and still failed, and what additional authorization or change controls apply before a real restart.
