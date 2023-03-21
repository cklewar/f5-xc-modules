resource "azurerm_public_ip" "compute_public_ip" {
  count               = var.disable_public_ip ? 0 : var.machine_count
  name                = "${element(var.machine_names, count.index)}-public-ip"
  location            = var.region
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "compute_nic_private" {
  count                         = var.disable_public_ip ? 0 : var.machine_count
  name                          = "${element(var.machine_names, count.index)}-private"
  location                      = var.region
  resource_group_name           = var.resource_group
  network_security_group_id     = var.security_group_private_id
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                                    = "balancer"
    subnet_id                               = var.subnet_private_id
    private_ip_address_allocation           = "dynamic"
    public_ip_address_id                    = try(element(azurerm_public_ip.compute_public_ip.*.id, count.index), "")
    load_balancer_backend_address_pools_ids = [var.lb_backend_id]
  }
}

resource "azurerm_network_interface" "compute_nic_private_without_public_ip" {
  count                         = var.disable_public_ip ? var.machine_count : 0
  name                          = "${element(var.machine_names, count.index)}-private"
  location                      = var.region
  resource_group_name           = var.resource_group
  network_security_group_id     = var.security_group_private_id
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                                    = "balancer"
    subnet_id                               = var.subnet_private_id
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = [var.lb_backend_id]
  }
}

resource "azurerm_network_interface" "compute_nic_inside" {
  count                         = var.machine_count
  name                          = "${element(var.machine_names, count.index)}-inside"
  location                      = var.region
  resource_group_name           = var.resource_group
  network_security_group_id     = var.security_group_private_id
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "inside"
    subnet_id                     = var.subnet_inside_id
    private_ip_address_allocation = "dynamic"
  }
}