output "secure-mesh-site" {
  value = {
    smg      = module.smg
    provider = {
      aws = length(module.aws) > 0 ? {
        ce     = module.aws[0].ce
        config = restapi_object.secure_mesh_site_aws
      } : null
      gcp = length(module.gcp) > 0 ? {
        ce     = module.gcp[0].ce
        config = restapi_object.secure_mesh_site_gcp
      } : null
      azure = length(module.azure) > 0 ? {
        ce     = module.azure[0].ce
        config = restapi_object.secure_mesh_site_azure
      } : null
      /*vmware = length(module.vmware) > 0 ? {
        ce     = module.vmware[0].ce
        config = restapi_object.secure_mesh_site_azure
      } : null*/
    }
  }
}