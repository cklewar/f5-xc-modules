locals {
  sg_slo_secure_ce_id          = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? length(module.aws_security_group_slo_secure_ce) > 0 ? module.aws_security_group_slo_secure_ce[0].aws_security_group["id"] : "" : ""
  sg_slo_secure_ce_extended_id = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? length(module.aws_security_group_slo_secure_ce_extended) > 0 ? module.aws_security_group_slo_secure_ce_extended[0].aws_security_group["id"] : "" : ""
  sg_sli_id                    = var.is_multi_nic ? module.aws_security_group_sli[0].aws_security_group["id"] : ""
  sg_sli_secure_ce_id          = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.aws_security_group_sli_secure_ce[0].aws_security_group["id"] : ""
}