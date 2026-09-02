resource "aws_instance" "lab" {

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.lab.id
  ]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  user_data = file("${path.module}/userdata.sh")

  user_data_replace_on_change = true

  root_block_device {

    volume_size = 30

    volume_type = "gp3"

    encrypted = true
  }

  tags = {
    Name = "prod-support-lab"
  }
}

resource "aws_eip" "lab" {

  domain = "vpc"

  instance = aws_instance.lab.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "prod-support-lab-eip"
  }
}