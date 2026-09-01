Yes. For your first iteration, I would actually keep the AWS side simple and put the complexity inside Docker Compose. Terraform should only provision:

VPC
Public subnet
Internet Gateway
Route table
Security Group
SSH key pair
Ubuntu EC2 instance
Elastic IP

Then the EC2's bootstrap script installs:

Docker
Docker Compose
Nginx
PostgreSQL
Redis
Prometheus
Grafana

and deploys the training environment automatically.

Below is a single main.tf file you can use as a starting point.

Prerequisites

Create a keypair locally:

ssh-keygen -t rsa -b 4096


Copy your public key:

cat ~/.ssh/id_rsa.pub

main.tf
terraform {

  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#########################################
# VARIABLES
#########################################

variable "public_key" {
  description = "SSH Public Key"
  type        = string
}

#########################################
# VPC
#########################################

resource "aws_vpc" "lab" {

  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "DevOps-Lab-VPC"
  }
}

#########################################
# SUBNET
#########################################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

#########################################
# INTERNET GATEWAY
#########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "Lab-IGW"
  }
}

#########################################
# ROUTE TABLE
#########################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#########################################
# SECURITY GROUP
#########################################

resource "aws_security_group" "lab" {

  name   = "devops-lab-sg"
  vpc_id = aws_vpc.lab.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-Lab-SG"
  }
}

#########################################
# KEYPAIR
#########################################

resource "aws_key_pair" "lab" {

  key_name   = "devops-lab-key"
  public_key = var.public_key
}

#########################################
# UBUNTU EC2
#########################################

resource "aws_instance" "training" {

  ami                         = "ami-04d29b6f966df1537"
  instance_type               = "t3.large"
  associate_public_ip_address = true

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.lab.id
  ]

  key_name = aws_key_pair.lab.key_name

  user_data = <<-EOF
#!/bin/bash

apt-get update -y

apt-get install -y \
docker.io \
docker-compose \
git \
curl \
htop \
dnsutils \
postgresql-client \
redis-tools

systemctl enable docker
systemctl start docker

mkdir -p /opt/training

cat > /opt/training/docker-compose.yml << 'DOCKER'

services:

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app

  app:
    image: nginxdemos/hello

  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: training
      POSTGRES_USER: student
      POSTGRES_PASSWORD: Training123

  redis:
    image: redis:latest

  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"

DOCKER

cat > /opt/training/nginx.conf << 'NGINX'

server {

    listen 80;

    location / {
        proxy_pass http://app:80;
    }
}

NGINX

cd /opt/training

docker compose up -d

EOF

  tags = {
    Name = "DevOps-Training-Lab"
  }
}

#########################################
# ELASTIC IP
#########################################

resource "aws_eip" "lab" {

  domain = "vpc"

  tags = {
    Name = "Lab-EIP"
  }
}

resource "aws_eip_association" "lab" {

  allocation_id = aws_eip.lab.id
  instance_id   = aws_instance.training.id
}

#########################################
# OUTPUTS
#########################################

output "server_ip" {
  value = aws_eip.lab.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_eip.lab.public_ip}"
}

output "grafana_url" {
  value = "http://${aws_eip.lab.public_ip}:3000"
}

output "application_url" {
  value = "http://${aws_eip.lab.public_ip}"
}

terraform.tfvars

Create a second file:

public_key = "ssh-rsa AAAAB3Nz..."


Paste your public key on that line.

Deploy
terraform init

terraform plan

terraform apply

What This Builds

After about 3-5 minutes you'll have:

AWS

VPC
│
├── Public Subnet
├── Internet Gateway
├── Route Table
├── Security Group
├── Elastic IP
│
└── Ubuntu EC2
      │
      ├── Docker
      ├── Nginx
      ├── Redis
      ├── PostgreSQL
      ├── Prometheus
      └── Grafana


From there, the first five labs become simple break/fix scripts executed on the EC2:

docker stop app          # Lab 1

bad nginx config         # Lab 2

expired TLS cert         # Lab 3

broken DNS               # Lab 4

docker stop redis        # Lab 5


This gives you a reusable foundation that can later expand to PostgreSQL incidents, monitoring failures, Docker networking issues, and eventually K3s/Kubernetes troubleshooting labs.