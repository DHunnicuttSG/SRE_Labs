variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "key_pair_name" {
  type = string
}