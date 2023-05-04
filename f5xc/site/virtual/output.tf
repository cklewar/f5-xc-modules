output "virtual_site" {
  value = {
    id        = volterra_virtual_site.virtual_site.id
    name      = volterra_virtual_site.virtual_site.name
    site_type = volterra_virtual_site.virtual_site.site_type
  }
}