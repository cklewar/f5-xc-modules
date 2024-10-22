resource "azurerm_linux_virtual_machine" "instance" {
  tags                            = var.common_tags
  name                            = var.f5xc_node_name
  size                            = var.azurerm_instance_vm_size
  zone                            = var.azurerm_az != null ? var.azurerm_az : null
  location                        = var.azurerm_region
  custom_data                     = base64encode(var.f5xc_instance_config)
  computer_name                   = var.f5xc_node_name
  admin_username                  = var.azurerm_instance_admin_username
  admin_password                  = var.azurerm_instance_admin_password != "" ? var.azurerm_instance_admin_password : null
  availability_set_id             = var.azurerm_availability_set_id != "" ? var.azurerm_availability_set_id : null
  resource_group_name             = var.azurerm_resource_group_name
  network_interface_ids           = var.azurerm_instance_network_interface_ids
  disable_password_authentication = var.azurerm_disable_password_authentication

  admin_ssh_key {
    username   = var.azurerm_instance_admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = var.azurerm_instance_disk_size
    storage_account_type = var.azurerm_os_disk_storage_account_type
  }

  source_image_reference {
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
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [azurerm_linux_virtual_machine.instance]
  retry        = var.f5xc_registration_retry
  hostname     = azurerm_linux_virtual_machine.instance.name
  wait_time    = var.f5xc_registration_wait_time
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_node_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  retry      = var.f5xc_registration_retry
  wait_time  = var.f5xc_registration_wait_time
}