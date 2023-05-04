output "virtual_site" {
  value = {
    id            = volterra_virtual_site.virtual_site.id
    name          = volterra_virtual_site.virtual_site.name
    labels        = volterra_virtual_site.virtual_site.labels
    site_type     = volterra_virtual_site.virtual_site.site_type
    description   = volterra_virtual_site.virtual_site.description
    site_selector = volterra_virtual_site.virtual_site.site_selector
  }
}