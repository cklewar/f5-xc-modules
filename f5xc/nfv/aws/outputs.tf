output "nfv" {
  value = {
    id                       = volterra_nfv_service.nfv.id
    name                     = volterra_nfv_service.nfv.name
    namespace                = volterra_nfv_service.nfv.namespace
    virtual_server_ip        = local.nfv_virtual_server_ip
    disable_ssh_access       = volterra_nfv_service.nfv.disable_ssh_access
    disable_https_management = volterra_nfv_service.nfv.disable_https_management
    nodes                    = {
      instances             = {for node in data.aws_instance.nfv : node.tags["Name"] => node}
      external_interface_ip = {for interface in data.aws_network_interface.nfv_big_ip_external_interface : interface.tags["tag:ves.io/nfv-service-node-name"] => interface}
      internal_interface_ip = {for interface in data.aws_network_interface.nfv_big_ip_internal_interface : interface.tags["tag:ves.io/nfv-service-node-name"] => interface}
    }
  }
}