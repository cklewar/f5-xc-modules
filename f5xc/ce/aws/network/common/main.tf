resource "aws_vpc" "vpc" {
  count                = var.aws_existing_vpc_id == "" ? 1 : 0
  cidr_block           = var.aws_vpc_subnet_prefix
  enable_dns_support   = var.aws_vpc_enable_dns_support
  enable_dns_hostnames = var.aws_vp_enable_dns_hostnames
  tags                 = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  tags   = local.common_tags
}

resource "aws_route" "route_ipv4" {
  route_table_id         = data.aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "route_ipv6" {
  route_table_id              = data.aws_vpc.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}