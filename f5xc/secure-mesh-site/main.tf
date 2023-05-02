module "smg" {
  source                           = "../site-mesh-group"
  f5xc_tenant                      = var.f5xc_tenant
  f5xc_site_mesh_group_name        = var.f5xc_secure_mesh_name
  f5xc_site_2_site_connection_type = var.f5xc_site_2_site_connection_type
}

resource "restapi_object" "secure_mesh_site" {
  for_each     = var.f5xc_secure_mesh_site
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.secure_mesh_site[each.key]
  id_attribute = "metadata/name"
}

/*module "vsphere" {
  depends_on                                         = [restapi_object.secure_mesh_site]
  source                                             = "../ce/vsphere"
  count                                              = length(var.f5xc_secure_mesh_site.vmware) > 0 ? 1 : 0
  is_sensitive                                       = var.f5xc_secure_mesh_site.vmware.is_sensitive
  f5xc_tenant                                        = var.f5xc_tenant
  f5xc_api_url                                       = var.f5xc_api_url
  f5xc_namespace                                     = var.f5xc_namespace
  f5xc_api_token                                     = var.f5xc_api_token
  f5xc_cluster_name                                  = var.f5xc_secure_mesh_site.vmware.f5xc_cluster_name
  f5xc_site_latitude                                 = var.f5xc_secure_mesh_site.vmware.f5xc_cluster_latitude
  f5xc_site_longitude                                = var.f5xc_secure_mesh_site.vmware.f5xc_cluster_longitude
  f5xc_ce_gateway_type                               = var.f5xc_secure_mesh_site.vmware.f5xc_ce_gateway_type
  f5xc_vsphere_site_nodes                            = var.f5xc_secure_mesh_site.vmware.nodes
  f5xc_vsphere_instance_template                     = var.f5xc_secure_mesh_site.vmware.f5xc_vsphere_instance_template
  vsphere_cluster                                    = var.f5xc_secure_mesh_site.vmware.vsphere_cluster
  vsphere_datacenter                                 = var.f5xc_secure_mesh_site.vmware.vsphere_datacenter
  vsphere_instance_dns_servers                       = var.f5xc_secure_mesh_site.vmware.vsphere_instance_dns_servers
  vsphere_instance_admin_password                    = var.f5xc_secure_mesh_site.vmware.vsphere_instance_admin_password
  vsphere_instance_inside_network_name               = var.f5xc_secure_mesh_site.vmware.vsphere_instance_inside_network_name
  vsphere_instance_outside_network_name              = var.f5xc_secure_mesh_site.vmware.vsphere_instance_outside_network_name
  vsphere_instance_outside_interface_default_route   = var.f5xc_secure_mesh_site.vmware.vsphere_instance_outside_interface_default_route
  vsphere_instance_outside_interface_default_gateway = var.f5xc_secure_mesh_site.vmware.vsphere_instance_outside_interface_default_gateway
}*/

module "aws" {
  depends_on                           = [restapi_object.secure_mesh_site]
  source                               = "../ce/aws"
  count                                = length(var.f5xc_secure_mesh_site.aws) > 0 ? 1 : 0
  owner_tag                            = var.f5xc_secure_mesh_site.aws.owner
  is_sensitive                         = var.f5xc_secure_mesh_site.aws.is_sensitive
  has_public_ip                        = var.f5xc_secure_mesh_site.aws.has_public_ip
  ssh_public_key                       = file(var.ssh_public_key_file)
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_api_url                         = var.f5xc_api_url
  f5xc_api_token                       = var.f5xc_api_token
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_aws_region                      = var.f5xc_secure_mesh_site.aws.region
  f5xc_token_name                      = var.f5xc_secure_mesh_site.aws.f5xc_token_name
  f5xc_cluster_name                    = var.f5xc_secure_mesh_site.aws.f5xc_cluster_name
  f5xc_cluster_labels                  = var.f5xc_secure_mesh_site.aws.f5xc_cluster_labels
  f5xc_aws_vpc_az_nodes                = var.f5xc_secure_mesh_site.aws.f5xc_nodes
  f5xc_ce_gateway_type                 = var.f5xc_secure_mesh_site.aws.f5xc_ce_gateway_type
  f5xc_cluster_latitude                = var.f5xc_secure_mesh_site.aws.f5xc_cluster_latitude
  f5xc_cluster_longitude               = var.f5xc_secure_mesh_site.aws.f5xc_cluster_longitude
  aws_vpc_cidr_block                   = var.f5xc_secure_mesh_site.aws.vpc_cidr_block
  aws_security_group_rules_slo_egress  = var.f5xc_secure_mesh_site.aws.security_group_rules_slo_egress
  aws_security_group_rules_slo_ingress = var.f5xc_secure_mesh_site.aws.security_group_rules_slo_ingress
}

module "gcp" {
  depends_on             = [restapi_object.secure_mesh_site]
  source                 = "../ce/gcp"
  count                  = length(var.f5xc_secure_mesh_site.gcp) > 0 ? 1 : 0
  is_sensitive           = false
  has_public_ip          = var.f5xc_secure_mesh_site.gcp.has_public_ip
  f5xc_tenant            = var.f5xc_tenant
  f5xc_api_url           = var.f5xc_api_url
  f5xc_ce_nodes          = var.f5xc_secure_mesh_site.gcp.f5xc_nodes
  f5xc_namespace         = var.f5xc_namespace
  f5xc_api_token         = var.f5xc_api_token
  f5xc_token_name        = var.f5xc_secure_mesh_site.gcp.f5xc_token_name
  f5xc_cluster_name      = var.f5xc_secure_mesh_site.gcp.f5xc_cluster_name
  f5xc_cluster_labels    = var.f5xc_secure_mesh_site.gcp.f5xc_cluster_labels
  f5xc_ce_gateway_type   = var.f5xc_secure_mesh_site.gcp.f5xc_ce_gateway_type
  f5xc_cluster_latitude  = var.f5xc_secure_mesh_site.gcp.f5xc_cluster_latitude
  f5xc_cluster_longitude = var.f5xc_secure_mesh_site.gcp.f5xc_cluster_longitude
  gcp_region             = var.f5xc_secure_mesh_site.gcp.region
  machine_type           = var.f5xc_secure_mesh_site.gcp.machine_type
  project_name           = var.f5xc_secure_mesh_site.gcp.project_name
  machine_image          = var.f5xc_secure_mesh_site.gcp.machine_image
  ssh_public_key         = var.ssh_public_key_file
  machine_disk_size      = var.f5xc_secure_mesh_site.gcp.machine_disk_size
}

/*module "azure" {
  depends_on                      = [restapi_object.secure_mesh_site]
  source                          = "../ce/azure"
  count                           = var.f5xc_site_type == var.f5xc_site_type_azure ? 1 : 0
  owner_tag                       = var.azurerm_owner
  is_sensitive                    = false
  has_public_ip                   = var.f5xc_azure_ce_has_public_ip
  azurerm_tenant_id               = var.azurerm_tenant_id
  azurerm_client_id               = var.azurerm_client_id
  azurerm_client_secret           = var.azurerm_client_secret
  azurerm_subscription_id         = var.azurerm_subscription_id
  azurerm_vnet_address_space      = var.azurerm_vnet_address_space
  azure_security_group_rules_slo  = var.azure_security_group_rules_slo
  azurerm_instance_admin_username = var.azurerm_instance_admin_username
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_namespace                  = var.f5xc_namespace
  f5xc_azure_region               = var.f5xc_azure_region
  f5xc_cluster_name               = var.f5xc_azure_cluster_name
  f5xc_azure_az_nodes             = var.f5xc_azure_az_nodes
  f5xc_cluster_labels             = var.f5xc_cluster_labels
  f5xc_ce_gateway_type            = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude           = var.f5xc_azure_site_latitude
  f5xc_cluster_longitude          = var.f5xc_azure_site_longitude
  ssh_public_key                  = file(var.ssh_public_key_file)
}*/