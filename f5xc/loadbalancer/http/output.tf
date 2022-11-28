output "loadbalancer" {
  value = {
    "name"    = volterra_http_loadbalancer.lb.name
    "id"      = volterra_http_loadbalancer.lb.id
    "domains" = volterra_http_loadbalancer.lb.domains
  }
}