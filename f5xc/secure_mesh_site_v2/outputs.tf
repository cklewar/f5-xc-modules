output "secure_mesh_site" {
  value = {
    # site = volterra_securemesh_site_v2.site
    token = {
      key       = restful_resource.token.output.spec.content
      type      = restful_resource.token.output.spec.type
      state     = restful_resource.token.output.spec.state
      algorithm = local.algorithm
    }
  }
}