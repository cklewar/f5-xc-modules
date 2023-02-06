module "common" {
  source                = "./common"
  owner_tag             = var.owner_tag
  aws_vpc_subnet_prefix = var.aws_vpc_subnet_prefix
}

module "nodes" {
  source                              = "./nodes"
  owner_tag                           = var.owner_tag
  cluster_name                        = var.f5xc_cluster_name
  f5xc_ce_gateway_type                = var.f5xc_ce_gateway_type
  aws_region                          = var.f5xc_aws_region
  aws_vpc_az                          = var.aws_vpc_az
  aws_subnet_sli_cidr                 = var.aws_subnet_sli_cidr
  aws_subnet_slo_cidr                 = var.aws_subnet_slo_cidr
  aws_vpc_subnet_prefix               = var.aws_vpc_subnet_prefix
  aws_security_group_rule_sli_egress  = var.aws_security_group_rule_sli_egress
  aws_security_group_rule_sli_ingress = var.aws_security_group_rule_sli_ingress
  aws_security_group_rule_slo_egress  = var.aws_security_group_rule_slo_egress
  aws_security_group_rule_slo_ingress = var.aws_security_group_rule_slo_ingress
}