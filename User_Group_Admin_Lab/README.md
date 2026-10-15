# Linux User and Group Administration Lab

A hands-on lab for creating groups, managing supplementary group membership, setting group ownership and permissions, and configuring shared-directory behavior with setgid and `umask`. Run it in an isolated Docker container or a disposable Linux VM; setup creates local Linux accounts and a group.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build user-group-admin-lab
docker compose run --rm user-group-admin-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/user-group-admin-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a disposable Linux VM

This lab changes the VM's local accounts and creates a group. Do not run it on a shared or production system. From this directory, initialize the exercise, then open a root shell to complete the tasks:

```sh
sudo bash setup.sh
sudo -i
cd /opt/user_group_admin_practice
```

After completing the tasks, exit the root shell. From this directory, run the grader:

```sh
sudo bash grade.sh
```

Setup refuses to overwrite an existing `/opt/user_group_admin_practice` directory or reuse any of the lab account/group names. On a VM, remove the exercise directory and lab accounts/group yourself before starting over.

## Source lesson

- [Assign permissions to a group](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/Advanced/Assign_permissions_to_group.md)

The lab also covers least-privilege verification and effective permissions for new files in a shared directory.