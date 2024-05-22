output "gcp_vpc" {
  value = {
    vpc   = volterra_gcp_vpc_site.site
    nodes = {
      node0 = data.google_compute_instance.node0
      node1 = var.f5xc_gcp_node_number == 3 ? data.google_compute_instance.node1 : null
      node2 = var.f5xc_gcp_node_number == 3 ? data.google_compute_instance.node2 : null
    }
    params = volterra_tf_params_action.gcp_vpc_action
  }
}