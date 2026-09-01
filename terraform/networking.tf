resource "aws_vpc" "lab" {

  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod-support-lab-vpc"
  }
}

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.100.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "prod-support-lab-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "prod-support-lab-igw"
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "prod-support-lab-public-rt"
  }
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}