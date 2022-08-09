output "gcp_vpc" {
  value = {
    "name"          = volterra_gcp_vpc_site.gcp_site.name
    "id"            = volterra_gcp_vpc_site.gcp_site.id
    "region"        = volterra_gcp_vpc_site.gcp_site.gcp_region
    "instance_type" = volterra_gcp_vpc_site.gcp_site.instance_type
  }
}