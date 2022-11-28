resource "volterra_fleet" "fleet" {
  name        = var.f5xc_fleet_name
  namespace   = var.f5xc_namespace
  fleet_label = var.f5xc_fleet_label

  dynamic "network_connectors" {
    for_each = var.f5xc_network_connectors
    content {
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
      name      = network_connectors.value
    }
  }

  interface_list {
    dynamic "interfaces" {
      for_each = var.f5xc_networks_interface_list
      content {
        tenant    = var.f5xc_tenant
        namespace = var.f5xc_namespace
        name      = interfaces.value
      }
    }
  }

  dynamic "outside_virtual_network" {
    for_each = var.f5xc_outside_virtual_network
    content {
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
      name      = outside_virtual_network.value
    }
  }

  dynamic "inside_virtual_network" {
    for_each = var.f5xc_inside_virtual_network
    content {
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
      name      = inside_virtual_network.value
    }
  }

  no_bond_devices                      = var.f5xc_no_bond_devices
  no_dc_cluster_group                  = var.f5xc_no_dc_cluster_group
  disable_gpu                          = var.f5xc_disable_gpu
  disable_vm                           = var.f5xc_disable_vm
  logs_streaming_disabled              = var.f5xc_logs_streaming_disabled
  default_storage_class                = var.f5xc_default_storage_class
  no_storage_device                    = var.f5xc_no_storage_device
  no_storage_interfaces                = var.f5xc_no_storage_device
  no_storage_static_routes             = var.f5xc_no_storage_interfaces
  enable_default_fleet_config_download = var.f5xc_enable_default_fleet_config_download
  deny_all_usb                         = var.f5xc_deny_all_usb
}