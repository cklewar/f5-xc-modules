output "ce" {
  value = {
    slo        = module.network_interface_slo.aws_network_interface
    sli        = var.is_multi_nic ? module.network_interface_sli.0.aws_network_interface : null
    slo_subnet = var.aws_existing_slo_subnet_id != null ? data.aws_subnet.slo.0 : aws_subnet.slo.0
    sli_subnet = var.is_multi_nic ? var.aws_existing_sli_subnet_id != null ? data.aws_subnet.sli.0 : aws_subnet.sli.0 : null
  }
}