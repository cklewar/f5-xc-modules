output "gcp_vpc" {
  value = {
    name          = volterra_gcp_vpc_site.site.name
    id            = volterra_gcp_vpc_site.site.id
    region        = volterra_gcp_vpc_site.site.gcp_region
    instance_type = volterra_gcp_vpc_site.site.instance_type
    params        = volterra_tf_params_action.gcp_vpc_action
  }
}