output "ce" {
  value = {
    slo        = module.network_interface_slo.aws_network_interface
    sli        = var.is_multi_nic ? module.network_interface_sli[0].aws_network_interface : null
    slo_subnet = aws_subnet.slo
    sli_subnet = var.is_multi_nic ? aws_subnet.sli[0] : null
  }
}