resource "aws_vpc" "vpc" {
  count                = var.create_new_aws_vpc  ? 1 : 0
  tags                 = var.common_tags
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = var.aws_vpc_enable_dns_support
  enable_dns_hostnames = var.aws_vp_enable_dns_hostnames
}

module "aws_security_group_slo" {
  source                      = "../../../../../aws/security_group"
  aws_vpc_id                  = var.create_new_aws_vpc == false && var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = var.common_tags
  description                 = "F5 XC CLOUD CE SLO SG"
  aws_security_group_name     = format("%s-sg-slo", var.f5xc_cluster_name)
  security_group_rule_egress  = var.aws_security_group_rules_slo_egress
  security_group_rule_ingress = var.aws_security_group_rules_slo_ingress
}

module "aws_security_group_sli" {
  source                      = "../../../../../aws/security_group"
  count                       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  aws_vpc_id                  = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = var.common_tags
  description                 = "F5 XC CLOUD CE SLI SG"
  aws_security_group_name     = format("%s-sg-sli", var.f5xc_cluster_name)
  security_group_rule_egress  = var.aws_security_group_rules_sli_egress
  security_group_rule_ingress = var.aws_security_group_rules_sli_ingress
}

module "aws_security_group_slo_secure_ce" {
  source                      = "../../../../../aws/security_group"
  count                       = var.f5xc_is_secure_cloud_ce ? 1 : 0
  aws_vpc_id                  = var.create_new_aws_vpc == false && var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = var.common_tags
  description                 = "F5 XC SECURE CLOUD CE SLO SG"
  aws_security_group_name     = format("%s-sg-slo-secure-ce", var.f5xc_cluster_name)
  security_group_rule_egress  = var.aws_security_group_rules_slo_egress_secure_ce
  security_group_rule_ingress = var.aws_security_group_rules_slo_ingress_secure_ce
}

module "aws_security_group_sli_secure_ce" {
  source                      = "../../../../../aws/security_group"
  count                       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress && var.f5xc_is_secure_cloud_ce? 1 : 0
  aws_vpc_id                  = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = var.common_tags
  description                 = "F5 XC SECURE CLOUD CE SLI SG"
  aws_security_group_name     = format("%s-sg-sli-secure-ce", var.f5xc_cluster_name)
  security_group_rule_egress  = var.aws_security_group_rules_sli_egress_secure_ce
  security_group_rule_ingress = var.aws_security_group_rules_sli_ingress_secure_ce
}

resource "aws_internet_gateway" "igw" {
  tags   = var.common_tags
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
}

resource "aws_route" "route_ipv4" {
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = data.aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "route_ipv6" {
  gateway_id                  = aws_internet_gateway.igw.id
  route_table_id              = data.aws_vpc.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
}