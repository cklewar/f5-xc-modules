output "ce" {
  value = {
    slo_subnet = aws_subnet.slo
    sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli[0] : null
    slo        = module.network_interface_slo.aws_network_interface
    sli        = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_interface_sli[0].aws_network_interface : null
  }
}