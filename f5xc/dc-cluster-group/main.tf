resource "volterra_dc_cluster_group" "dc_cluster_group" {
  name        = var.f5xc_dc_cluster_group_name
  labels      = var.f5xc_dc_cluster_group_labels
  namespace   = var.f5xc_namespace
  description = var.f5xc_dc_cluster_group_description != "" ? var.f5xc_dc_cluster_group_description : null
}