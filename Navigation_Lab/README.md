# Linux Navigation Lab

A short, repeatable command-line exercise for practicing filesystem navigation and basic file/directory operations. It runs in a Linux Bash shell (including WSL) or in Docker.

## Run with Docker

From this directory, build and start the interactive lab:
* If Docker Compose is not installed use these commands:
```sh
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version
```

Otherwise just run these two commands:
```sh
docker compose build navigation-lab
docker compose run --rm navigation-lab
```

You are now inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/navigation-lab/grade.sh
```

The container is temporary. Exiting it discards the student's work; run the command again for a clean attempt.

## Run in a Linux Bash shell

From this directory, initialize the exercise in your home directory, then follow `STUDENT.md` in that Bash session:

```sh
bash setup.sh
```

When finished, grade it from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/navigation_lab`. To reset a local attempt, remove that exercise directory yourself and run setup again.

See `INSTRUCTOR.md` for the answer key and grading details.