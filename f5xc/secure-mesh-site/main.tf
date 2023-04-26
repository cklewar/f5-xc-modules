resource "restapi_object" "secure_mesh_site" {
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.secure_mesh_site_config
  id_attribute = "metadata/name"
}

module "vsphere" {
  depends_on           = [restapi_object.secure_mesh_site]
  source               = "../ce/vsphere"
  count                = var.f5xc_site_type == var.f5xc_site_type_vsphere ? 1 : 0
  f5xc_tenant          = var.f5xc_tenant
  f5xc_api_url         = var.f5xc_api_url
  f5xc_namespace       = var.f5xc_namespace
  f5xc_api_token       = var.f5xc_api_token
  f5xc_reg_url         = var.f5xc_ves_reg_url
  f5xc_vm_template     = var.f5xc_site_vsphere_vm_template
  vsphere_user         = var.f5xc_site_username
  vsphere_password     = var.f5xc_site_password
  vsphere_server       = var.f5xc_site_vsphere_server
  vsphere_datacenter   = var.f5xc_site_vsphere_datacenter
  vsphere_cluster      = var.f5xc_site_vsphere_cluster
  cpus                 = var.f5xc_site_vsphere_cpu_count
  nodes                = var.f5xc_secure_mesh_site_nodes
  memory               = var.f5xc_site_vsphere_memory
  guest_type           = var.f5xc_site_vsphere_guest_type
  dnsservers           = var.f5xc_site_vsphere_dns_servers
  cluster_name         = var.f5xc_cluster_name
  sitelatitude         = var.f5xc_site_latitude
  sitelongitude        = var.f5xc_site_longitude
  outside_network      = var.f5xc_site_vsphere_outside_network
  certifiedhardware    = var.f5xc_site_type_certified_hw[var.f5xc_site_type]
  publicdefaultroute   = var.f5xc_site_vsphere_public_default_route
  publicdefaultgateway = var.f5xc_site_vsphere_public_default_gateway
}