output "common" {
  value = {
    vpc              = var.aws_existing_vpc_id != "" ? null : aws_vpc.vpc[0]
    igw              = aws_internet_gateway.igw
    sg_slo           = module.aws_security_group_slo.aws_security_group
    sg_sli           = var.is_multi_nic ? module.aws_security_group_sli[0].aws_security_group : null
    sg_slo_secure_ce = var.f5xc_is_secure_cloud_ce ? module.aws_security_group_slo_secure_ce : null
    sg_sli_secure_ce = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.aws_security_group_sli_secure_ce : null
    slo_subnet_rt    = aws_route_table.slo_subnet_rt
    sli_subnet_rt    = var.is_multi_nic ? aws_route_table.sli_subnet_rt[0] : null
    existing_vpc     = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc : null
  }
}