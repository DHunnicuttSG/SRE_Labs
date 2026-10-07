# Linux Networking Lab

A hands-on Linux networking exercise with a repeatable local HTTP service. It runs in an isolated Docker container and does not require access to external hosts for the graded tasks.

## Run with Docker

Docker Engine and the Docker Compose v2 plugin are required. From this directory, build and start the interactive lab:

```sh
docker compose build networking-lab
docker compose run --rm networking-lab
```

If `docker compose` is not recognized on an Amazon Linux x86_64 EC2 instance, install the Compose plugin:

```sh
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version
```

For an `aarch64` instance, use `docker-compose-linux-aarch64` in the download URL instead.

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/linux-networking-lab/grade.sh
```

The container and its work are discarded when you exit. Rebuild or rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

Command references: [Linux Commands List](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/1.0-Linux_Commands_List.md) and [Need To Know Commands](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/1.1-Need_To_Know_Commands.md).