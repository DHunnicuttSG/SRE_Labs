# System Info and Processes Lab

A hands-on Linux exercise for identifying a system, reading resource summaries, and inspecting and managing a safe test process. The lab runs in an interactive Ubuntu Docker container.

## Run with Docker

Docker Engine and the Docker Compose v2 plugin are required. From this directory:

```sh
docker compose build system-info-and-processes-lab
docker compose run --rm system-info-and-processes-lab
```

If `docker compose` is not recognized on Amazon Linux, install the Compose plugin as described in the [Linux Networking Lab README](../Linux_Networking_Lab/README.md).

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/system-info-and-processes-lab/grade.sh
```

The container and its work are discarded when you exit. This lab includes `vmstat` from the Ubuntu `procps` package. It excludes `iostat`, `systemctl`, `journalctl`, and `strace`; systemd is not running in the container, and ptrace-based tracing can be restricted by container security settings.