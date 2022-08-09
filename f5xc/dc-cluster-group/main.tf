resource "volterra_dc_cluster_group" "dc_cluster_group" {
  name      = var.f5xc_dc_cluster_group_name
  namespace = var.f5xc_namespace
}