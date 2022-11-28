resource "volterra_dc_cluster_group" "dc_cluster_group" {
  name        = var.f5xc_dc_cluster_group_name
  namespace   = var.f5xc_namespace
  labels      = var.f5xc_dc_cluster_group_labels
  description = var.f5xc_dc_cluster_group_description != "" ? var.f5xc_dc_cluster_group_description : null
}