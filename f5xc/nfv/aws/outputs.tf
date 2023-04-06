output "nfv" {
  value = {
    id                       = volterra_nfv_service.nfv.id
    name                     = volterra_nfv_service.nfv.name
    namespace                = volterra_nfv_service.nfv.namespace
    virtual_server_ip        = local.nfv_virtual_server_ip
    disable_ssh_access       = volterra_nfv_service.nfv.disable_ssh_access
    disable_https_management = volterra_nfv_service.nfv.disable_https_management
    pan_commands             = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? jsondecode(data.http.pan_commands.*.response_body[0])["spec"]["commands"] : null
    nodes                    = {
      node1              = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? {for node in data.aws_instance.nfv_bigip_node1 : node.tags["Name"] => node} : null
      node2              = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service && length(var.f5xc_aws_nfv_nodes) > 1 ? {for node in data.aws_instance.nfv_bigip_node2 : node.tags["Name"] => node} : null
      instances          = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? {for node in data.aws_instance.nfv_pan : node.tags["Name"] => node} : null
      external_interface = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? {
        for interface in data.aws_network_interface.nfv_big_ip_external_interface_node1 : interface.tags["ves.io/nfv-service-node-name"] => interface
      } : null
      internal_interface = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? {
        for interface in data.aws_network_interface.nfv_big_ip_internal_interface_node1 : interface.tags["ves.io/nfv-service-node-name"] => interface
      } : null
    }
  }
}