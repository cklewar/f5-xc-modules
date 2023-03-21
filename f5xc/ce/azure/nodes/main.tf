resource "azurerm_virtual_machine" "instance" {
  depends_on                       = [azurerm_marketplace_agreement.volterra]
  count                            = local.enable_sli == true && var.use_availability_set ? local.nodes_count : 0
  tags                             = var.common_tags
  name                             = element(var.machine_names, count.index)
  vm_size                          = lookup(element(var.nodes, count.index), "machine_type", "Standard_F2")
  location                         = var.f5xc_azure_region
  availability_set_id              = var.availability_set_id
  resource_group_name              = azurerm_resource_group_name
  network_interface_ids            = [element(local.slo_nic_ids, count.index), element(local.sli_nic_ids, count.index)]
  primary_network_interface_id     = element(local.slo_nic_ids, count.index)
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = element(var.nodes, count.index).marketplace.publisher
    offer     = element(var.nodes, count.index).marketplace.offer
    sku       = element(var.nodes, count.index).marketplace.sku
    version   = element(var.nodes, count.index).marketplace.version
  }

  plan {
    name      = element(var.nodes, count.index).marketplace.name
    publisher = element(var.nodes, count.index).marketplace.publisher
    product   = element(var.nodes, count.index).marketplace.offer
  }

  storage_os_disk {
    name          = "${element(var.machine_names, count.index)}-system"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = try(tonumber(element(local.disk_sizes, count.index)), 50)
  }

  os_profile {
    admin_username = var.admin_username
    computer_name  = element(var.machine_names, count.index)
    custom_data    = var.machine_config
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.machine_admin}/.ssh/authorized_keys"
      key_data = var.public_ssh_key
    }
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [azurerm_virtual_machine.instance]
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
  hostname     = regex("[0-9A-Za-z_-]+", aws_instance.instance.private_dns)
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