#!/bin/bash

set -ex

dnf update -y

dnf install -y \
docker \
git \
curl \
wget \
jq \
python3 \
python3-pip

systemctl enable docker
systemctl start docker

mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

usermod -aG docker ec2-user

mkdir -p /opt/prod-support-lab

cat <<EOF >/etc/motd

=========================================
PRODUCTION SUPPORT TRAINING LAB
=========================================

Installed:
- Docker
- Docker Compose
- Python3
- Git

Lab Directory:
  /opt/prod-support-lab

=========================================

EOF