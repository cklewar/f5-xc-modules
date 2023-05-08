output "gcp_vpc" {
  value = {
    vpc   = volterra_gcp_vpc_site.site
    nodes = {
      node0 = {
        for index, name in local.f5xc_instance_names : name => data.google_compute_instance.node0[index] if data.google_compute_instance.node0[index].id != null
      }
      node1 = {
        for index, name in local.f5xc_instance_names : name => data.google_compute_instance.node1[index] if data.google_compute_instance.node1[index].id != null
      }
      node2 = {
        for index, name in local.f5xc_instance_names : name => data.google_compute_instance.node2[index] if data.google_compute_instance.node2[index].id != null
      }
    }
    params = volterra_tf_params_action.gcp_vpc_action
  }
}