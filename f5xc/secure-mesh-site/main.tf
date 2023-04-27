resource "restapi_object" "secure_mesh_site" {
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.secure_mesh_site_config
  id_attribute = "metadata/name"
}

module "vsphere" {
  depends_on                                         = [restapi_object.secure_mesh_site]
  source                                             = "../ce/vsphere"
  count                                              = var.f5xc_site_type == var.f5xc_site_type_vsphere ? 1 : 0
  is_sensitive                                       = false
  f5xc_tenant                                        = var.f5xc_tenant
  f5xc_api_url                                       = var.f5xc_api_url
  f5xc_namespace                                     = var.f5xc_namespace
  f5xc_api_token                                     = var.f5xc_api_token
  f5xc_vm_template                                   = var.f5xc_vsphere_instance_template
  f5xc_cluster_name                                  = var.f5xc_vsphere_cluster_name
  f5xc_site_latitude                                 = var.f5xc_vsphere_site_latitude
  f5xc_site_longitude                                = var.f5xc_vsphere_site_longitude
  f5xc_ce_gateway_type                               = var.f5xc_ce_gateway_type
  f5xc_vsphere_site_nodes                            = var.f5xc_secure_mesh_site_nodes
  vsphere_user                                       = var.vsphere_user
  vsphere_server                                     = var.vsphere_server
  vsphere_cluster                                    = var.vsphere_cluster
  vsphere_password                                   = var.vsphere_user_password
  vsphere_datacenter                                 = var.vsphere_datacenter
  vsphere_instance_dns_servers                       = var.vsphere_dns_servers
  vsphere_instance_admin_password                    = var.vsphere_instance_admin_password
  vsphere_instance_inside_network_name               = var.vsphere_instance_inside_network_name
  vsphere_instance_outside_network_name              = var.vsphere_instance_outside_network_name
  vsphere_instance_outside_interface_default_route   = var.vsphere_instance_outside_interface_default_route
  vsphere_instance_outside_interface_default_gateway = var.vsphere_instance_outside_interface_default_gateway
}

module "aws" {
  depends_on                           = [restapi_object.secure_mesh_site]
  source                               = "../ce/aws"
  count                                = var.f5xc_site_type == var.f5xc_site_type_aws ? 1 : 0
  owner_tag                            = var.aws_owner
  is_sensitive                         = false
  has_public_ip                        = var.f5xc_aws_ce_has_public_ip
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_api_url                         = var.f5xc_api_url
  f5xc_api_token                       = var.f5xc_api_token
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_aws_region                      = var.f5xc_aws_region
  f5xc_token_name                      = var.f5xc_token_name
  f5xc_cluster_name                    = var.f5xc_aws_cluster_name
  f5xc_cluster_labels                  = var.f5xc_cluster_labels
  f5xc_aws_vpc_az_nodes                = var.f5xc_aws_vpc_az_nodes
  f5xc_ce_gateway_type                 = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude                = var.f5xc_aws_site_latitude
  f5xc_cluster_longitude               = var.f5xc_aws_site_longitude
  aws_vpc_cidr_block                   = var.aws_vpc_cidr_block
  aws_security_group_rules_slo_egress  = var.aws_security_group_rules_slo_egress
  aws_security_group_rules_slo_ingress = var.aws_security_group_rules_slo_ingress
  ssh_public_key                       = file(var.ssh_public_key_file)
}

module "gcp" {
  depends_on             = [restapi_object.secure_mesh_site]
  source                 = "../ce/gcp"
  count                  = var.f5xc_site_type == var.f5xc_site_type_gcp ? 1 : 0
  is_sensitive           = false
  has_public_ip          = var.f5xc_gcp_ce_has_public_ip
  f5xc_tenant            = var.f5xc_tenant
  f5xc_api_url           = var.f5xc_api_url
  f5xc_namespace         = var.f5xc_namespace
  f5xc_api_token         = var.f5xc_api_token
  f5xc_token_name        = var.f5xc_token_name
  f5xc_fleet_label       = var.f5xc_cluster_labels
  f5xc_ce_gateway_type   = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude  = var.f5xc_gcp_site_latitude
  f5xc_cluster_longitude = var.f5xc_gcp_site_longitude
  gcp_region             = var.gcp_region
  machine_type           = var.f5xc_gcp_machine_type
  project_name           = var.gcp_project_name
  machine_image          = var.f5xc_gcp_machine_image
  instance_name          = var.f5xc_gcp_instance_name
  ssh_public_key         = var.ssh_public_key_file
  machine_disk_size      = var.f5xc_gcp_machine_disk_size
}

module "azure" {
  depends_on                      = [restapi_object.secure_mesh_site]
  source                          = "../ce/azure"
  count                           = var.f5xc_site_type == var.f5xc_site_type_azure ? 1 : 0
  owner_tag                       = ""
  is_sensitive                    = false
  has_public_ip                   = false
  azurerm_tenant_id               = ""
  azurerm_client_id               = ""
  azurerm_client_secret           = ""
  azurerm_subscription_id         = ""
  azurerm_vnet_address_space      = []
  azure_security_group_rules_slo  = []
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
}