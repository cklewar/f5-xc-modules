output "hcl2json" {
  value = data.external.instance.result
}

output "gcp_vpc" {
  value = {
    name              = volterra_gcp_vpc_site.site.name
    id                = volterra_gcp_vpc_site.site.id
    region            = volterra_gcp_vpc_site.site.gcp_region
    slo_ip            = data.google_compute_instance.instance.network_interface.0.network_ip
    sli_ip            = data.google_compute_instance.instance.network_interface.1.network_ip
    params            = volterra_tf_params_action.gcp_vpc_action
    public_ip         = data.google_compute_instance.instance.network_interface.0.access_config.0.nat_ip
    instance_type     = volterra_gcp_vpc_site.site.instance_type
    network_interface = data.google_compute_instance.instance.network_interface
  }
}