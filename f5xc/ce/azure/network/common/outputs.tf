output "common" {
  value = {
    vnet          = azurerm_virtual_network.volterra_net != "" ? null : aws_vpc.vpc[0]
    sg_slo        = module.sg_slo.security_group
    sg_sli        = var.is_multi_nic ? module.sg_sli.security_group[0] : null
    # sg_slo_secure_ce          = var.f5xc_is_secure_cloud_ce ? module.aws_security_group_slo_secure_ce : null
    # sg_slo_secure_ce_extended = var.f5xc_is_secure_cloud_ce ? module.aws_security_group_slo_secure_ce_extended : null
    # sg_sli_secure_ce          = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.aws_security_group_sli_secure_ce : null
    # slo_subnet_rt             = aws_route_table.slo_subnet_rt
    # sli_subnet_rt             = var.is_multi_nic ? aws_route_table.sli_subnet_rt[0] : null
    existing_vnet = var.azurerm_existing_virtual_network_name != "" ? data.aws_vpc.vpc : null
    # sg_slo_ids                = [module.aws_security_group_slo.aws_security_group["id"], local.sg_slo_secure_ce_id, local.sg_slo_secure_ce_extended_id]
    # sg_sli_ids                = [local.sg_sli_id, local.sg_sli_secure_ce_id]
  }
}