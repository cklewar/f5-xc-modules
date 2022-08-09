output "virtual-network" {
  value = {
    "name"           = volterra_virtual_network.virtual_network.name
    "id"             = volterra_virtual_network.virtual_network.id
    "global_network" = volterra_virtual_network.virtual_network.global_network
  }
}