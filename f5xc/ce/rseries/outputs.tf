output "ce" {
  value = {
    f5os_tenant      = restapi_object.f5os_tenant
    secure_mesh_site = module.sms.secure_mesh_site
  }
}