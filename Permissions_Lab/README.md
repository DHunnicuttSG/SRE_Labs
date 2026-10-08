# Linux Permissions Lab

A hands-on lab for Linux file and directory permissions, ownership, groups, and `umask`. The exercises run in an isolated Ubuntu container with a non-root student account and disposable files.

## Run with Docker

Docker Engine and the Docker Compose v2 plugin are required. From this directory, build and start the interactive lab:

```sh
docker compose build permissions-lab
docker compose run --rm permissions-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/permissions-lab/grade.sh
```

The container and its work are discarded when you exit. Rebuild or rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Source lessons

- [Linux File Permissions](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/3.3-File_Permissions.md)
- [Linux File Permissions Exercises](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/3.3.1-Permission_Ex.md)