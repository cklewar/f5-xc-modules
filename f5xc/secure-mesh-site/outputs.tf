output "secure-mesh-site" {
  value = {
    smg   = module.smg
    sites = {
      aws = {
        ce     = module.aws[0].ce
        config = restapi_object.secure_mesh_site["aws"].api_data
      }
      gcp = {
        ce     = module.gcp[0].ce
        config = restapi_object.secure_mesh_site["gcp"].api_data
      }
      azure = {
        ce     = module.azure[0].ce
        config = restapi_object.secure_mesh_site["azure"].api_data
      }
    }
  }
}