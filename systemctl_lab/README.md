# Linux systemctl and journalctl Lab

A self-contained, read-only command-line lab for production support analysts. Practice identifying failed services, inspecting unit state and configuration, and correlating service logs across time, severity, and boots.

The lab provides fixture-backed `systemctl` and `journalctl` commands on its private `PATH`. They operate only on the lab's synthetic data; they do not connect to or modify the host's systemd manager. State-changing operations are intentionally unsupported.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build systemctl-lab
docker compose run --rm systemctl-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/systemctl-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a Linux Bash shell

Initialize the exercise in your home directory and activate its command shims:

```sh
bash setup.sh
source "$HOME/systemctl_practice/lab-env.sh"
cd "$HOME/systemctl_practice"
```

Complete `STUDENT.md`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/systemctl_practice`. Remove that exercise directory yourself to start over. The simulated commands are available only in shells where `lab-env.sh` has been sourced.

## Source lessons

- [Advanced systemctl and journalctl](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Adv-Systemctl_Journalctl.md)
- [systemctl and journalctl Cheat Sheet](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Adv-Systemctl_Journalctl_Cheat_Sheet.md)
