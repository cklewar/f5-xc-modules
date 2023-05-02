output "secure-mesh-site" {
  value = {
    smg   = module.smg
    sites = {
      aws = {
        ce     = module.aws
        config = restapi_object.secure_mesh_site["aws"].api_data
      }
      gcp = {
        ce     = module.gcp
        config = restapi_object.secure_mesh_site["gcp"].api_data
      }
      //vmware = module.vsphere
    }
    /*for key in keys(var.f5xc_secure_mesh_site) : key => {
      ce     = var.f5xc_secure_mesh_site[key]
      config = local.secure_mesh_site[key]
    }*/
  }
}