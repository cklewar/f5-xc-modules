resource "azurerm_virtual_machine" "instance" {
  tags                             = var.common_tags
  name                             = var.f5xc_node_name
  vm_size                          = var.azurerm_instance_vm_size
  location                         = var.f5xc_azure_region
  availability_set_id              = var.azurerm_availability_set_id != "" ? var.azurerm_availability_set_id : null
  resource_group_name              = var.azurerm_resource_group_name
  network_interface_ids            = var.azurerm_instance_network_interface_ids
  primary_network_interface_id     = var.azurerm_primary_network_interface_id
  delete_os_disk_on_termination    = var.azurerm_instance_delete_os_disk_on_termination
  delete_data_disks_on_termination = var.azurerm_instance_delete_data_disks_on_termination

  storage_image_reference {
    sku       = var.azurerm_marketplace_plan
    offer     = var.azurerm_marketplace_offer
    version   = var.azurerm_marketplace_version
    publisher = var.azurerm_marketplace_publisher
  }

  plan {
    name      = var.azurerm_marketplace_plan
    product   = var.azurerm_marketplace_offer
    publisher = var.azurerm_marketplace_publisher
  }

  storage_os_disk {
    name          = "${var.f5xc_node_name}-system"
    os_type       = "Linux"
    create_option = "FromImage"
    disk_size_gb  = var.azurerm_instance_disk_size
  }

  os_profile {
    custom_data    = var.f5xc_instance_config
    computer_name  = var.f5xc_node_name
    admin_username = var.azurerm_instance_admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.azurerm_instance_admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [azurerm_virtual_machine.instance]
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
  hostname     = azurerm_virtual_machine.instance.name
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_node_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}