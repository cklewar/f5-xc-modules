output "dc-cluster-group" {
  value = {
    "name" = volterra_dc_cluster_group.dc_cluster_group.name
    "id"   = volterra_dc_cluster_group.dc_cluster_group.id
  }
}