output "secure_mesh_site" {
  value = {
    site = restful_resource.site.output
    token = {
      key       = restful_resource.token.output.spec.content
      type      = restful_resource.token.output.spec.type
      state     = restful_resource.token.output.spec.state
      algorithm = local.algorithm
    }
  }
}