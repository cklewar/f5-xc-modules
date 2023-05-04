output "site_mesh_group" {
  value = {
    id           = volterra_site_mesh_group.site_mesh_group.id
    name         = volterra_site_mesh_group.site_mesh_group.name
    type         = volterra_site_mesh_group.site_mesh_group.type
    labels       = volterra_site_mesh_group.site_mesh_group.labels
    description  = volterra_site_mesh_group.site_mesh_group.description
    virtual_site = volterra_site_mesh_group.site_mesh_group.virtual_site[0]
  }
}