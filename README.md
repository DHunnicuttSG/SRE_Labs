# SRE Labs

Hands-on labs for Linux administration, site reliability engineering, containerized applications, monitoring, and AWS infrastructure.

## Lab Catalog

| Lab | Summary | Start here |
| --- | --- | --- |
| Linux Navigation | Practice shell navigation and basic file and directory operations. | [Lab guide](Navigation_Lab/README.md) |
| Linux Grep | Practice fixed-string and regular-expression searches, grep options, recursive search, and pipelines. | [Lab guide](Grep_Lab/README.md) |
| Linux Awk | Practice field selection, filtering, calculations, formatting, and log analysis with awk. | [Lab guide](awk_Lab/README.md) |
| Linux Sed | Practice stream editing with substitutions, addressing, in-place edits, and pipelines. | [Lab guide](Sed_Lab/README.md) |
| Linux Networking | Inspect interfaces, routes, DNS, connectivity, and a local HTTP service. | [Lab guide](Linux_Networking_Lab/README.md) |
| System Info and Processes | Collect system resource information and inspect and manage a test process. | [Lab guide](System_Info_And_Processes_Lab/README.md) |
| Linux Permissions | Practice changing permissions on files and directories. | [Lab guide](Permissions_Lab/README.md) |
| User/Group Admin | Practice Linux user and group administration. | In progress |

<!-- | Docker SRE | Explore ticketing and inventory apps alongside Prometheus, Grafana, Loki, Alloy, and Alertmanager. | [Lab guide](Docker_lab/README.md) |
| AWS Terraform | Provision AWS infrastructure with Terraform. | [Build guide](AWS_TF_Lab/How_To_Build_Lab.md) | -->

## Run a Lab

The command-line labs run in Linux containers. You can run them on an Amazon Linux 2023 EC2 instance or on Windows with Docker Desktop. Install Git and Docker once, then follow the selected lab's guide for its Compose commands and grading instructions.

### Windows with Docker Desktop

Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and [Git for Windows](https://git-scm.com/download/win). Start Docker Desktop and wait until it reports that Docker is running.

Open PowerShell and clone the repository, then enter its folder. If you already cloned it, just change to that folder:

```powershell
git clone https://github.com/DHunnicuttSG/SRE_Labs.git
Set-Location .\SRE_Labs
```

From the repository folder, change into the selected lab's folder and run the commands in its README. For example:

```powershell
Set-Location .\Navigation_Lab
docker compose build navigation-lab
docker compose run --rm navigation-lab
```

The lab starts in an interactive Linux shell. Follow its `STUDENT.md`; each lab guide gives the grader command and explains whether your work is kept after you exit.

### Amazon Linux 2023 on EC2

Connect to the instance over SSH, then install and start Docker and Git:

```bash
sudo dnf install -y docker git
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
```

Log out of SSH and reconnect so the new Docker group membership takes effect. Verify Docker:

```bash
docker version
```

Docker Compose is included in some Docker installations. Check first:

```bash
docker compose version
```

If that command is unavailable on an x86_64 instance, install the Compose plugin:

```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version
```

For an ARM (`aarch64`) instance, use `docker-compose-linux-aarch64` in the download URL instead. Then clone the repository and run the selected lab from its directory:

```bash
git clone https://github.com/DHunnicuttSG/SRE_Labs.git
cd SRE_Labs/Navigation_Lab
docker compose build navigation-lab
docker compose run --rm navigation-lab
```

Follow that lab's `STUDENT.md` and README for the exercise and grader command. Most shell labs run in temporary containers, so work inside the container is discarded when you exit.

<!-- ### Docker SRE App Lab

The Docker SRE lab starts web apps and monitoring services rather than an interactive shell. Follow [its README](Docker_lab/README.md) for startup, URLs, credentials, and shutdown commands. Do not expose the training services publicly without securing them first.

### AWS Terraform Lab

The Terraform lab provisions AWS resources and is separate from running the command-line labs on an EC2 host. Follow the [Terraform build guide](AWS_TF_Lab/How_To_Build_Lab.md), and review the resources it creates and their potential AWS costs before deploying. -->

## Adding a Lab

Add one row to the catalog with the lab name, a one-sentence summary, and a relative link to its primary README or build guide. Keep setup steps and exercise details in that lab's folder.