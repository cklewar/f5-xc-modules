output "dc_cluster_group" {
  value = {
    id   = volterra_dc_cluster_group.dc_cluster_group.id
    name = volterra_dc_cluster_group.dc_cluster_group.name

  }
}