resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  tags                 = merge({ Name = var.aws_vpc_name, Owner = var.aws_owner }, var.custom_tags)
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = var.aws_vpc_name, Owner = var.aws_owner }, var.custom_tags)
}