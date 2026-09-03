#!/bin/bash

set -xe

# Update packages
dnf update -y

# Install required packages
dnf install -y docker git jq

# Start Docker
systemctl enable docker
systemctl start docker

# Allow ec2-user access
usermod -aG docker ec2-user

# Install Docker Compose
mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL \
https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Install Buildx
curl -SL \
https://github.com/docker/buildx/releases/download/v0.28.0/buildx-v0.28.0.linux-amd64 \
-o /usr/local/lib/docker/cli-plugins/docker-buildx

chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx


# Verify
docker compose version
docker buildx version

# Lab folder
mkdir -p /opt

cd /opt

git clone ${github_repo}

echo "Repository cloned successfully"

cd /opt/SRE_Labs/docker

docker compose up -d

echo "Bootstrap completed"