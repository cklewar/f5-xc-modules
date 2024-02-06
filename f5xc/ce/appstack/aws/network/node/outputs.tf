output "ce" {
  value = {
    slo        = module.network_interface_slo.aws_network_interface
    slo_subnet = var.aws_existing_slo_subnet_id != null ? data.aws_subnet.slo.0 : aws_subnet.slo.0
  }
}