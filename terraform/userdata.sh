#!/bin/bash

set -xe

# Update packages
dnf update -y

# Install required packages
dnf install -y \
docker \
git \
jq

# Start Docker
systemctl enable docker
systemctl start docker

# Allow ec2-user access
usermod -aG docker ec2-user

# Install Docker Compose
mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Lab folder
mkdir -p /opt/prod-support-lab

echo "Bootstrap completed"