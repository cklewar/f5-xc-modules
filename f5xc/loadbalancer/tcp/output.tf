output "loadbalancer" {
  value = {
    "name"    = volterra_tcp_loadbalancer.loadbalancer.names
    "id"      = volterra_tcp_loadbalancer.loadbalancer.id
    "domains" = volterra_tcp_loadbalancer.loadbalancer.domains
  }
}