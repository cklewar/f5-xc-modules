output "nfv" {
  value = {
    id                       = volterra_nfv_service.nfv.id
    name                     = volterra_nfv_service.nfv.name
    namespace                = volterra_nfv_service.nfv.namespace
    instances                = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? {for node in data.aws_instance.nfv_pan : node.tags["Name"] => node} : null
    is_cluster               = length(var.f5xc_aws_nfv_nodes) > 1 ? true : false
    pan_commands             = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? jsondecode(data.http.pan_commands.*.response_body[0])["spec"]["commands"] : null
    virtual_server_ip        = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? local.nfv_virtual_server_ip : null
    disable_ssh_access       = volterra_nfv_service.nfv.disable_ssh_access
    disable_https_management = volterra_nfv_service.nfv.disable_https_management
    nodes                    = {
      names = keys(var.f5xc_aws_nfv_nodes)
      count = length(var.f5xc_aws_nfv_nodes)
      node1 = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? {
        instance   = lookup(data.aws_instance.nfv_bigip_node1, keys(var.f5xc_aws_nfv_nodes)[0])
        public_dns = format("%s.%s", keys(var.f5xc_aws_nfv_nodes)[0], var.f5xc_nfv_domain_suffix)
        interfaces = {
          external = lookup(data.aws_network_interface.nfv_big_ip_external_interface_node1, keys(var.f5xc_aws_nfv_nodes)[0])
          internal = lookup(data.aws_network_interface.nfv_big_ip_internal_interface_node1, keys(var.f5xc_aws_nfv_nodes)[0])
        }
      } : null
      node2 = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service && local.is_cluster ? {
        instance   = lookup(data.aws_instance.nfv_bigip_node2, keys(var.f5xc_aws_nfv_nodes)[1])
        public_dns = format("%s.%s", keys(var.f5xc_aws_nfv_nodes)[1], var.f5xc_nfv_domain_suffix)
        interfaces = {
          external = lookup(data.aws_network_interface.nfv_big_ip_external_interface_node2, keys(var.f5xc_aws_nfv_nodes)[1])
          internal = lookup(data.aws_network_interface.nfv_big_ip_internal_interface_node2, keys(var.f5xc_aws_nfv_nodes)[1])
        }
      } : null
    }
  }
}