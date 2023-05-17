module "smg" {
  source                                = "../site-mesh-group"
  count                                 = var.f5xc_create_site_mesh_group ? 1 : 0
  f5xc_tenant                           = var.f5xc_tenant
  f5xc_virtual_site_name                = var.f5xc_virtual_site_name != "" ? var.f5xc_virtual_site_name : format("%s-%s-%s", var.f5xc_secure_mesh_site_prefix, "vs", var.f5xc_secure_mesh_site_suffix)
  f5xc_create_virtual_site              = var.f5xc_create_virtual_site
  f5xc_site_mesh_group_name             = var.f5xc_site_mesh_group_name != "" ? var.f5xc_site_mesh_group_name : format("%s-%s-%s", var.f5xc_secure_mesh_site_prefix, "smg", var.f5xc_secure_mesh_site_suffix)
  f5xc_site_2_site_connection_type      = var.f5xc_site_2_site_connection_type
  f5xc_virtual_site_selector_expression = length(var.f5xc_virtual_site_selector_expression) > 0 ? var.f5xc_virtual_site_selector_expression : local.virtual_site_selector_expression
}

resource "restapi_object" "secure_mesh_site_aws" {
  for_each     = contains(keys(local.secure_mesh_site_data), "aws") ? {for index, site in local.secure_mesh_site_data["aws"] : site.name => site.json} : {}
  path         = "/config/namespaces/system/securemesh_sites"
  data         = each.value
  id_attribute = "metadata/name"
}

resource "restapi_object" "secure_mesh_site_gcp" {
  for_each     = contains(keys(local.secure_mesh_site_data), "gcp") ? {for index, site in local.secure_mesh_site_data["gcp"] : site.name => site.json} : {}
  path         = "/config/namespaces/system/securemesh_sites"
  data         = each.value
  id_attribute = "metadata/name"
}

resource "restapi_object" "secure_mesh_site_azure" {
  for_each     = contains(keys(local.secure_mesh_site_data), "azure") ? {for index, site in local.secure_mesh_site_data["azure"] : site.name => site.json} : {}
  path         = "/config/namespaces/system/securemesh_sites"
  data         = each.value
  id_attribute = "metadata/name"
}

resource "restapi_object" "secure_mesh_site_vmware" {
  for_each     = contains(keys(local.secure_mesh_site_data), "vmware") ? {for index, site in local.secure_mesh_site_data["vmware"] : site.name => site.json} : {}
  path         = "/config/namespaces/system/securemesh_sites"
  data         = each.value
  id_attribute = "metadata/name"
}

/*module "vmware" {
  depends_on                                         = [restapi_object.secure_mesh_site_vmware]
  source                                             = "../ce/vsphere_new"
  count                                              = var.f5xc_secure_mesh_site.vmware != null ? length(var.f5xc_secure_mesh_site.vmware) : 0
  is_sensitive                                       = var.f5xc_secure_mesh_site.vmware[count.index].is_sensitive
  f5xc_tenant                                        = var.f5xc_tenant
  f5xc_api_url                                       = var.f5xc_api_url
  f5xc_namespace                                     = var.f5xc_namespace
  f5xc_api_token                                     = var.f5xc_api_token
  f5xc_cluster_name                                  = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_cluster_name
  f5xc_site_latitude                                 = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_cluster_latitude
  f5xc_site_longitude                                = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_cluster_longitude
  f5xc_ce_gateway_type                               = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_ce_gateway_type
  f5xc_vsphere_site_nodes                            = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_nodes
  f5xc_vsphere_instance_template                     = var.f5xc_secure_mesh_site.vmware[count.index].f5xc_vsphere_instance_template
  vsphere_cluster                                    = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_cluster
  vsphere_datacenter                                 = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_datacenter
  vsphere_instance_dns_servers                       = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_dns_servers
  vsphere_instance_admin_password                    = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_admin_password
  vsphere_instance_inside_network_name               = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_inside_network_name
  vsphere_instance_outside_network_name              = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_outside_network_name
  vsphere_instance_outside_interface_default_route   = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_outside_interface_default_route
  vsphere_instance_outside_interface_default_gateway = var.f5xc_secure_mesh_site.vmware[count.index].vsphere_instance_outside_interface_default_gateway
}*/

module "aws" {
  depends_on                           = [restapi_object.secure_mesh_site_aws]
  source                               = "../ce/aws"
  count                                = var.f5xc_secure_mesh_site.aws != null ? length(var.f5xc_secure_mesh_site.aws) : 0
  owner_tag                            = var.f5xc_secure_mesh_site.aws[count.index].owner
  is_sensitive                         = var.f5xc_secure_mesh_site.aws[count.index].is_sensitive
  has_public_ip                        = var.f5xc_secure_mesh_site.aws[count.index].has_public_ip
  ssh_public_key                       = file(var.ssh_public_key_file)
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_api_url                         = var.f5xc_api_url
  f5xc_api_token                       = var.f5xc_api_token
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_aws_region                      = var.f5xc_secure_mesh_site.aws[count.index].region
  f5xc_token_name                      = var.f5xc_secure_mesh_site.aws[count.index].f5xc_token_name
  f5xc_cluster_name                    = var.f5xc_secure_mesh_site.aws[count.index].f5xc_cluster_name
  f5xc_cluster_labels                  = var.f5xc_secure_mesh_site.aws[count.index].f5xc_cluster_labels
  f5xc_aws_vpc_az_nodes                = var.f5xc_secure_mesh_site.aws[count.index].f5xc_nodes
  f5xc_ce_gateway_type                 = var.f5xc_secure_mesh_site.aws[count.index].f5xc_ce_gateway_type
  f5xc_cluster_latitude                = var.f5xc_secure_mesh_site.aws[count.index].f5xc_cluster_latitude
  f5xc_cluster_longitude               = var.f5xc_secure_mesh_site.aws[count.index].f5xc_cluster_longitude
  aws_vpc_cidr_block                   = var.f5xc_secure_mesh_site.aws[count.index].vpc_cidr_block
  aws_security_group_rules_slo_egress  = var.f5xc_secure_mesh_site.aws[count.index].security_group_rules_slo_egress
  aws_security_group_rules_slo_ingress = var.f5xc_secure_mesh_site.aws[count.index].security_group_rules_slo_ingress
}

module "gcp" {
  depends_on             = [restapi_object.secure_mesh_site_gcp]
  source                 = "../ce/gcp"
  count                  = var.f5xc_secure_mesh_site.gcp != null ? length(var.f5xc_secure_mesh_site.gcp) : 0
  is_sensitive           = var.f5xc_secure_mesh_site.gcp[count.index].is_sensitive
  has_public_ip          = var.f5xc_secure_mesh_site.gcp[count.index].has_public_ip
  f5xc_tenant            = var.f5xc_tenant
  f5xc_api_url           = var.f5xc_api_url
  f5xc_ce_nodes          = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_nodes
  f5xc_namespace         = var.f5xc_namespace
  f5xc_api_token         = var.f5xc_api_token
  f5xc_token_name        = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_token_name
  f5xc_cluster_name      = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_cluster_name
  f5xc_cluster_labels    = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_cluster_labels
  f5xc_ce_gateway_type   = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_ce_gateway_type
  f5xc_cluster_latitude  = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_cluster_latitude
  f5xc_cluster_longitude = var.f5xc_secure_mesh_site.gcp[count.index].f5xc_cluster_longitude
  gcp_region             = var.f5xc_secure_mesh_site.gcp[count.index].region
  machine_type           = var.f5xc_secure_mesh_site.gcp[count.index].machine_type
  project_name           = var.f5xc_secure_mesh_site.gcp[count.index].project_name
  machine_image          = var.f5xc_secure_mesh_site.gcp[count.index].machine_image
  machine_disk_size      = var.f5xc_secure_mesh_site.gcp[count.index].machine_disk_size
  ssh_public_key         = var.ssh_public_key_file
}

module "azure" {
  depends_on                      = [restapi_object.secure_mesh_site_azure]
  source                          = "../ce/azure"
  count                           = var.f5xc_secure_mesh_site.azure != null ? length(var.f5xc_secure_mesh_site.azure) : 0
  owner_tag                       = var.f5xc_secure_mesh_site.azure[count.index].owner
  is_sensitive                    = var.f5xc_secure_mesh_site.azure[count.index].is_sensitive
  has_public_ip                   = var.f5xc_secure_mesh_site.azure[count.index].has_public_ip
  ssh_public_key                  = file(var.ssh_public_key_file)
  azurerm_tenant_id               = var.f5xc_secure_mesh_site.azure[count.index].tenant_id
  azurerm_client_id               = var.f5xc_secure_mesh_site.azure[count.index].client_id
  azurerm_client_secret           = var.f5xc_secure_mesh_site.azure[count.index].client_secret
  azurerm_subscription_id         = var.f5xc_secure_mesh_site.azure[count.index].subscription_id
  azurerm_vnet_address_space      = var.f5xc_secure_mesh_site.azure[count.index].vnet_address_space
  azure_security_group_rules_slo  = var.f5xc_secure_mesh_site.azure[count.index].security_group_rules_slo
  azurerm_instance_admin_username = var.f5xc_secure_mesh_site.azure[count.index].instance_admin_username
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_namespace                  = var.f5xc_namespace
  f5xc_azure_region               = var.f5xc_secure_mesh_site.azure[count.index].region
  f5xc_cluster_name               = var.f5xc_secure_mesh_site.azure[count.index].f5xc_cluster_name
  f5xc_azure_az_nodes             = var.f5xc_secure_mesh_site.azure[count.index].f5xc_nodes
  f5xc_cluster_labels             = var.f5xc_secure_mesh_site.azure[count.index].f5xc_cluster_labels
  f5xc_ce_gateway_type            = var.f5xc_secure_mesh_site.azure[count.index].f5xc_ce_gateway_type
  f5xc_cluster_latitude           = var.f5xc_secure_mesh_site.azure[count.index].f5xc_cluster_latitude
  f5xc_cluster_longitude          = var.f5xc_secure_mesh_site.azure[count.index].f5xc_cluster_longitude
}