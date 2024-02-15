output "common" {
  value = {
    vpc                       = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc.0 : aws_vpc.vpc.0
    igw                       = var.create_new_aws_igw ? aws_internet_gateway.igw.0 : null
    sg_slo                    = length(module.aws_security_group_slo) > 0 ? module.aws_security_group_slo.0.aws_security_group : null
    sg_sli                    = var.is_multi_nic ? module.aws_security_group_sli.0.aws_security_group : null
    sg_slo_secure_ce          = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? module.aws_security_group_slo_secure_ce : null
    sg_slo_secure_ce_extended = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? module.aws_security_group_slo_secure_ce_extended : null
    sg_sli_secure_ce          = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.aws_security_group_sli_secure_ce : null
    slo_subnet_rt             = var.create_new_aws_slo_rt ? aws_route_table.slo_subnet_rt.0 : null
    sli_subnet_rt             = var.is_multi_nic && var.create_new_aws_sli_rt ? aws_route_table.sli_subnet_rt.0 : null
    sg_slo_ids                = compact([
      length(module.aws_security_group_slo) > 0 ? module.aws_security_group_slo.0.aws_security_group["id"] : "",
      local.sg_slo_secure_ce_id, local.sg_slo_secure_ce_extended_id
    ])
    sg_sli_ids = var.is_multi_nic ? [local.sg_sli_id, local.sg_sli_secure_ce_id] : null
  }
}