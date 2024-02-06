resource "aws_vpc" "vpc" {
  count                = var.create_new_aws_vpc  ? 1 : 0
  tags                 = var.common_tags
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = var.aws_vpc_enable_dns_support
  enable_dns_hostnames = var.aws_vp_enable_dns_hostnames
}

module "aws_security_group_slo" {
  source                       = "../../../../../../aws/security_group"
  count                        = var.aws_security_group_rules_slo_egress != null ? 1 : 0
  aws_vpc_id                   = var.create_new_aws_vpc == false && var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                  = var.common_tags
  description                  = "F5 XC CLOUD CE SLO SG"
  aws_security_group_name      = format("%s-sg-slo", var.f5xc_cluster_name)
  security_group_rules_egress  = var.aws_security_group_rules_slo_egress
  security_group_rules_ingress = var.aws_security_group_rules_slo_ingress
}

resource "aws_internet_gateway" "igw" {
  tags   = merge({ Name : format("%s-igw", var.f5xc_cluster_name) }, var.common_tags)
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
}

resource "aws_route_table" "slo_subnet_rt" {
  tags   = merge({ Name : format("%s-slo-rt", var.f5xc_cluster_name) }, var.common_tags)
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }
}