output "loadbalancer" {
  value = {
    "name"    = volterra_tcp_loadbalancer.lb.name
    "id"      = volterra_tcp_loadbalancer.lb.id
    "domains" = volterra_tcp_loadbalancer.lb.domains
  }
}