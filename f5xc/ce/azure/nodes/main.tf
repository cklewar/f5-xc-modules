resource "azurerm_virtual_machine" "instance" {
  name                             = element(var.machine_names, count.index)
  location                         = var.region
  resource_group_name              = var.resource_group
  vm_size                          = var.machine_type
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  availability_set_id              = var.availability_set_id
  primary_network_interface_id     = element(local.private_nic_ids, count.index)

  network_interface_ids = [
    element(local.private_nic_ids, count.index),
    element(
      azurerm_network_interface.compute_nic_inside.*.id,
      count.index,
    ),
  ]

  storage_image_reference {
    id = var.machine_image
  }

  storage_os_disk {
    name          = "${element(var.machine_names, count.index)}-system"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = var.machine_disk_size
  }

  os_profile {
    computer_name  = element(var.machine_names, count.index)
    admin_username = var.machine_admin
    admin_password = ""
    custom_data    = var.machine_config
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.machine_admin}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }
  tags = {
    iam_owner = var.owner_tag
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