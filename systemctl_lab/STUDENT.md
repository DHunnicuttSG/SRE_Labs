# Student Exercise: systemctl and journalctl

## Goal

Practice a production-support workflow: find the failed unit, inspect its state and unit definition, then use the journal to identify when and why the failure began.

This lab uses synthetic fixtures behind read-only command shims. Commands resemble `systemctl` and `journalctl`, but they do not access a running systemd manager. Start in the lab workspace and inspect the fixture layout:

```sh
pwd
ls
```

Save command output while displaying it with `| tee reports/name.txt`. For example:

```sh
systemctl --failed | tee reports/q01.txt
```

## Triage

1. List failed units. Save to `reports/q01.txt`.
2. Inspect the detailed status of `payments-api.service`. Save to `reports/q02.txt`.
3. Check only the active state of `payments-api.service`. Save to `reports/q03.txt`.
4. Check whether `payments-api.service` is enabled at boot. Save to `reports/q04.txt`. Active state and enabled state answer different questions.
5. Show the unit's `ActiveState`, `SubState`, `Result`, `ExecMainStatus`, and `FragmentPath` properties. Save to `reports/q05.txt`.
6. Inspect the effective unit definition for `payments-api.service`. Save to `reports/q06.txt`.
7. Show the unit's dependencies. Save to `reports/q07.txt`.

## Journal investigation

8. Show the most recent eight journal entries for `payments-api.service`. Save to `reports/q08.txt`.
9. Show warning-severity and more severe entries for that service. Save to `reports/q09.txt`.
10. Inspect that service's journal from the previous boot. Save to `reports/q10.txt`.
11. List the recorded boots and their IDs. Save to `reports/q11.txt`.
12. Show kernel warnings and more severe messages. Save to `reports/q12.txt`.
13. Show service entries since `2026-10-16 09:30:00`. Save to `reports/q13.txt`.
14. Export the service's journal to `reports/payments-api.log`, then save the number of exported lines as `reports/q14.txt`.

## Challenge

Create a concise incident excerpt containing the two most recent warning-or-more-severe entries for `payments-api.service` from the previous boot. Save it to `reports/challenge.txt`.

## Production support reminders

- Start with read-only checks such as `systemctl --failed`, `systemctl status`, `systemctl show`, and `journalctl -u`; gather evidence before proposing a state-changing action.
- `is-active` reports runtime state; `is-enabled` reports boot-time enablement. A service can be enabled but currently failed, or active but disabled at boot.
- `systemctl cat` shows the effective unit definition, including drop-ins. After authorized unit-file changes on a real host, `systemctl daemon-reload` makes systemd reread unit definitions; it does not itself restart a service.
- Correlate timestamps, boot IDs, service messages, and kernel events. Use `journalctl -b -1` for a previous boot and `--since`/`--until` to bound an incident window.
- Journal access and retention depend on host configuration and permissions. Missing older entries do not prove an event did not occur.
- `restart`, `stop`, `disable`, `mask`, reboot, and power operations can affect availability. Confirm impact, authorization, and change procedure before using them in production.
- Exported logs may contain sensitive operational data. Limit the time range and unit scope, and redact before sharing.

Run the grader from any directory:

```sh
bash /opt/systemctl-lab/grade.sh
```

For a local Bash run, use `bash /path/to/systemctl_Lab/grade.sh`.
