resource "aws_security_group" "lab" {

  name        = "prod-support-lab-sg"
  description = "Prod Support Lab Security Group"
  vpc_id      = aws_vpc.lab.id

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.allowed_ssh_cidr
    ]
  }

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "Grafana"

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "Prometheus"

    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "Loki"

    from_port = 3100
    to_port   = 3100
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "AlertManager"

    from_port = 9093
    to_port   = 9093
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "prod-support-lab-sg"
  }
}