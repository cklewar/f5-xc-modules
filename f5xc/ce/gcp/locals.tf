locals {
  cluster_labels = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
  create_network = var.fabric_subnet_outside != "" || (var.fabric_subnet_inside != "" && var.fabric_subnet_outside != "") ? true : false
}