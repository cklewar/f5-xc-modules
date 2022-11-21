output "origin-pool" {
  value = {
    "name"                   = volterra_origin_pool.origin-pool.name
    "id"                     = volterra_origin_pool.origin-pool.id
    "endpoint_selection"     = volterra_origin_pool.origin-pool.endpoint_selection
    "loadbalancer_algorithm" = volterra_origin_pool.origin-pool.loadbalancer_algorithm
  }
}