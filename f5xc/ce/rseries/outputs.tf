output "ce" {
  value = {
    f5os_tenant      = restful_resource.f5os_tenant
    secure_mesh_site = module.sms.secure_mesh_site
  }
}