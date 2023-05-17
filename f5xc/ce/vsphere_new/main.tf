module "node" {
  source                                             = "./nodes"
  for_each                                           = {for k, v in var.f5xc_vsphere_site_nodes : k=>v}
  is_multi_nic                                       = local.is_multi_nic
  is_multi_node                                      = local.is_multi_node
  f5xc_tenant                                        = var.f5xc_tenant
  f5xc_api_url                                       = var.f5xc_api_url
  f5xc_api_token                                     = var.f5xc_api_token
  f5xc_namespace                                     = var.f5xc_namespace
  f5xc_node_name                                     = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name                                  = var.f5xc_cluster_name
  f5xc_site_latitude                                 = var.f5xc_site_latitude
  f5xc_site_longitude                                = var.f5xc_site_longitude
  f5xc_ce_gateway_type                               = var.f5xc_ce_gateway_type
  f5xc_vsphere_site_nodes                            = var.f5xc_vsphere_site_nodes
  f5xc_certified_hardware                            = var.f5xc_certified_hardware
  f5xc_vsphere_instance_template                     = var.f5xc_vsphere_instance_template
  vsphere_host                                       = each.value["host"]
  vsphere_cluster                                    = var.vsphere_cluster
  vsphere_datastore                                  = each.value["datastore"]
  vsphere_datacenter                                 = var.vsphere_datacenter
  vsphere_instance_cpu_count                         = var.vsphere_instance_cpu_count
  vsphere_instance_guest_type                        = var.vsphere_instance_guest_type
  vsphere_instance_memory_size                       = var.vsphere_instance_memory_size
  vsphere_instance_dns_servers                       = var.vsphere_instance_dns_servers
  vsphere_instance_admin_password                    = var.vsphere_instance_admin_password
  vsphere_instance_inside_network_name               = var.vsphere_instance_inside_network_name
  vsphere_instance_outside_network_name              = var.vsphere_instance_outside_network_name
  vsphere_instance_network_adapter_type              = each.value["adapter_type"]
  vsphere_instance_outside_interface_dhcp            = each.value["dhcp"]
  vsphere_instance_outside_interface_ip_address      = each.value["outside_network_ip_address"]
  vsphere_instance_outside_interface_default_route   = var.vsphere_instance_outside_interface_default_route
  vsphere_instance_outside_interface_default_gateway = var.vsphere_instance_outside_interface_default_gateway
}

module "site_wait_for_online" {
  depends_on     = [module.node]
  source         = "../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = var.f5xc_cluster_name
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}