output "loadbalancer" {
  value = {
    "name"    = volterra_http_loadbalancer.loadbalancer.name
    "id"      = volterra_http_loadbalancer.loadbalancer.id
    "domains" = volterra_http_loadbalancer.loadbalancer.domains
  }
}