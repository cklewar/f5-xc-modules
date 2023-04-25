resource "aws_vpc" "site" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = {
    Name    = var.vpc_name
    Creator = var.owner_tag
  }
}

resource "aws_internet_gateway" "k0s_gateway" {
  vpc_id = aws_vpc.site.id

  tags = {
    Name    = var.vpc_name
    Creator = var.owner_tag
  }
}

resource "aws_route_table" "k0s_route_table" {
  vpc_id = aws_vpc.site.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k0s_gateway.id
  }

  tags = {
    Name    = var.vpc_name
    Creator = var.owner_tag
  }
}

resource "aws_security_group" "allow_traffic" {
  name        = "${var.vpc_name}-allow-traffic"
  description = "allow ssh and smg traffic"
  vpc_id      = aws_vpc.site.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "4500"
    to_port     = "4500"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = var.vpc_name
    Creator = var.owner_tag
  }
}