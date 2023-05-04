output "secure-mesh-site" {
  value = {
    provider = {
      aws = length(module.aws) > 0 ? {
        ce   = module.aws[0].ce
        site = restapi_object.secure_mesh_site_aws
      } : null
      gcp = length(module.gcp) > 0 ? {
        ce   = module.gcp[0].ce
        site = restapi_object.secure_mesh_site_gcp
      } : null
      azure = length(module.azure) > 0 ? {
        ce   = module.azure[0].ce
        site = restapi_object.secure_mesh_site_azure
      } : null
      /*vmware = length(module.vmware) > 0 ? {
        ce     = module.vmware[0].ce
        config = restapi_object.secure_mesh_site_azure
      } : null*/
    }
    site_mesh_group = var.f5xc_create_site_mesh_group ? module.smg[0].site_mesh_group : null
  }
}