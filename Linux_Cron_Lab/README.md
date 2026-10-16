# Linux Cron Jobs Lab

A hands-on lab for scheduling recurring shell scripts with Linux cron, checking the daemon, handling cron's minimal environment, and verifying job output. Use the disposable Docker environment or an existing Linux EC2 instance; this lab does not provision cloud resources.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build linux-cron-lab
docker compose run --rm linux-cron-lab
```

Inside the container, follow `STUDENT.md`. The container starts the cron daemon and opens a shell as the unprivileged `student` user. Run the grader with:

```sh
bash /opt/linux-cron-lab/grade.sh
```

The container and its work are discarded when you exit. A one-minute cron entry needs at least one minute to run; allow a minute or two before completing the verification exercise.

## Run on Linux or EC2

On an existing Linux host or EC2 instance, install and start cron if needed. Amazon Linux typically uses the `cronie` package and `crond` service; Ubuntu and Debian use the `cron` package and `cron` service:

```sh
sudo dnf install -y cronie
sudo systemctl enable --now crond
systemctl status crond
```

For Ubuntu or Debian, use `sudo apt install cron` and `sudo systemctl enable --now cron`, then check `systemctl status cron`. From this directory, initialize the files in your home directory:

```sh
bash setup.sh
```

Follow `STUDENT.md`, then grade from this directory:

```sh
bash grade.sh
```

The exercise installs entries only in your user's crontab. Remove the lab entries when finished, then remove `~/cron_practice` yourself. Do not schedule privileged or production-impacting commands as part of this exercise.

## Source lessons

- [Using Cron](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Using_Cron.md#L4)
- [Create a Cron Job That Runs Every Minute](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Create_Cron_1_Minute.md)