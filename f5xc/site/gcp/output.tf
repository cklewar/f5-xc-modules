output "gcp_vpc" {
  value = {
    id            = volterra_gcp_vpc_site.site.id
    name          = volterra_gcp_vpc_site.site.name
    region        = volterra_gcp_vpc_site.site.gcp_region
    slo_ip        = data.google_compute_instance.instance.network_interface.0.network_ip
    sli_ip        = data.google_compute_instance.instance.network_interface.1.network_ip
    params        = volterra_tf_params_action.gcp_vpc_action
    public_ip     = data.google_compute_instance.instance.network_interface.0.access_config.0.nat_ip
    instance_name = regex(local.f5xc_gcp_instance_name_pattern, volterra_tf_params_action.gcp_vpc_action.tf_output)[0]
    instance_type = volterra_gcp_vpc_site.site.instance_type
  }
}