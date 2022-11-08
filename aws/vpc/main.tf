resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  tags                 = merge({ Name = var.aws_vpc_name }, var.custom_tags)
}
