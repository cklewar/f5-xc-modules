output "bgp" {
  value = {
    "name" = volterra_bgp.bgp.name
    "id"   = volterra_bgp.bgp.id
  }
}