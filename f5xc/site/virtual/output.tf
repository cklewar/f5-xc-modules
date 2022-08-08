output "virtual-site" {
  value = {
    "name"      = volterra_virtual_site.virtual-site.name
    "id"        = volterra_virtual_site.virtual-site.id
    "site_type" = volterra_virtual_site.virtual-site.site_type
  }
}