output "site-mesh-group" {
  value = {
    "name"        = volterra_site_mesh_group.site_mesh_group.name
    "id"          = volterra_site_mesh_group.site_mesh_group.id
    "type"        = volterra_site_mesh_group.site_mesh_group.type
  }
}