output "fleet" {
  value = {
    "name"        = volterra_fleet.fleet.name
    "id"          = volterra_fleet.fleet.id
    "fleet_label" = volterra_fleet.fleet.fleet_label
  }
}