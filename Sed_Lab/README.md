# Linux Sed Lab

A self-contained command-line lab for transforming logs, configuration, and other text with GNU `sed`. It includes a local fixture dataset and works in Docker or a Linux Bash shell, including WSL.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build sed-lab
docker compose run --rm sed-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/sed-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a Linux Bash shell

From this directory, initialize the exercise in your home directory:

```sh
bash setup.sh
```

Complete `STUDENT.md` from `~/sed_practice`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/sed_practice`. Remove that exercise directory yourself to start over.

## Source material

- [Using the sed Command in Linux](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.2-sed.md)
- [Sed Practice Worksheet](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.2.1-sed_worksheet.md)
- [Sed Practice Answer Key](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.2.1-sed_answer_key.md)