output "nfv" {
  value = {
    "id"                    = data.aws_instance.nfv.id
    "virtual_server_ip"     = local.nfv_virtual_server_ip
    "external_interface_ip" = data.aws_network_interface.nfv_external_interface.private_ip
    "internal_interface_ip" = data.aws_network_interface.nfv_internal_interface.private_ip
  }
}