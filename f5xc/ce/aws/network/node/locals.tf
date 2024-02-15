locals {
  create_rt_association = var.f5xc_is_secure_or_private_cloud_ce ? 0 : var.aws_slo_subnet_rt_id != null ? 1 : 0
  aws_subnet_slo_id = var.aws_existing_slo_subnet_id != null ? data.aws_subnet.slo.0.id : aws_subnet.slo.0.id
  aws_subnet_sli_id = var.is_multi_nic ? var.aws_existing_sli_subnet_id != null ? data.aws_subnet.sli.0.id : aws_subnet.sli.0.id : null
}