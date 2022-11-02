output "nfv" {
  value = {
    "id"                    = data.aws_instance.nfv.id
    "subnet_id"             = data.aws_instance.nfv.subnet_id
    "private_ip"            = data.aws_instance.nfv.private_ip
    "private_dns"           = data.aws_instance.nfv.private_dns
    "virtual_server_ip"     = local.nfv_virtual_server_ip
    "external_interface_ip" = data.aws_network_interface.nfv_external_interface.private_ip
    "internal_interface_ip" = data.aws_network_interface.nfv_internal_interface.private_ip
  }
}