output "secure_mesh_site" {
  value = {
    site = jsondecode(restapi_object.secure_mesh_site.api_response)
    token = {
      key       = local.api_response.spec.content
      state     = local.api_response.spec.state
      algorithm = local.algorithm
    }
  }
}