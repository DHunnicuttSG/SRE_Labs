# SRE Labs

This repository contains hands-on labs for Linux administration, site reliability engineering, containerized applications, monitoring, and AWS infrastructure.

## Lab Catalog

| Lab | Summary | Start here |
| --- | --- | --- |
<!-- | AWS Terraform Lab | Provision an AWS EC2 host with Terraform and run the SRE lab environment on it. | [Build guide](AWS_TF_Lab/How_To_Build_Lab.md) | -->
<!-- | Docker SRE | Explore ticketing and inventory applications alongside Prometheus, Grafana, Loki, Alloy, and Alertmanager. | [75% Complete](Docker_lab/README.md) | -->
| Linux Navigation | Practice shell navigation and basic file and directory operations. | [Lab guide](Navigation_Lab/README.md) |
|Linux Grep|Practice fixed-string and regular-expression searches, grep options, recursive search, and pipelines.|[Lab guide](Grep_Lab/README.md)|
| Linux Networking | Inspect interfaces, routes, DNS, connectivity, and a local HTTP service. | [Lab guide](Linux_Networking_Lab/README.md) |
| System Info and Processes | Collect system resource information and inspect and manage a test process. | [Lab guide](System_Info_And_Processes_Lab/README.md) |
|Linux Permissions | Add remove permissions with files and folders | [Lab guide / Not Tested](Permissions_Lab/README.md)|
|User/Group Admin| Linux user and group admin | In progress|

## Adding a Lab

Add one row to the catalog with the lab's name, a one-sentence summary, and a relative link to its primary README or build guide. Keep setup steps and exercise details in that lab's folder.

## Installing git, docker, docker compose, and buildx(if needed)

### Install required packages
```bash
dnf install -y docker git
```

### Start Docker
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### Verify docker startup
```bash
sudo systemctl status docker
```

### Allow ec2-user access (Add your user to the docker group)
```bash
sudo usermod -aG docker ec2-user ($USER)
```

### Verify you are now part of the docker group
- start a new shell  
```bash
newgrp docker
```
- lists the groups in which you are a member  
```bash
groups 
```

### Install Docker Compose
```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -SL \
https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```

### Verify
```bash
docker compose version
```

### Install Buildx (if needed)
```bash
curl -SL \
https://github.com/docker/buildx/releases/download/v0.28.0/buildx-v0.28.0.linux-amd64 \
-o /usr/local/lib/docker/cli-plugins/docker-buildx

chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx
```

### Verify
```bash
docker buildx version
```