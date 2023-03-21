resource "azurerm_public_ip" "compute_public_ip" {
  count               = var.has_public_ip ? 1 : 0
  name                = "${var.f5xc_node_name}-slo-public-ip"
  location            = var.f5xc_azure_region
  resource_group_name = var.f5xc_existing_azure_resource_group
  allocation_method   = var.azurerm_public_ip_allocation_method
}

resource "azurerm_network_interface" "slo" {
  name                          = "${var.f5xc_node_name}-slo"
  location                      = var.f5xc_azure_region
  resource_group_name           = var.f5xc_existing_azure_resource_group
  network_security_group_id     = var.azurerm_security_group_slo_id
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                                    = "slo"
    subnet_id                               = var.subnet_slo_id
    private_ip_address_allocation           = var.azurerm_private_ip_address_allocation
    public_ip_address_id                    = var.has_public_ip ? azurerm_public_ip.compute_public_ip.*.id : null
    load_balancer_backend_address_pools_ids = [var.lb_backend_id]
  }
}

resource "azurerm_network_interface" "sli" {
  count                         = var.is_multi_nic ? 1 : 0
  name                          = "${var.f5xc_node_name}-sli"
  location                      = var.f5xc_azure_region
  resource_group_name           = var.f5xc_existing_azure_resource_group
  network_security_group_id     = var.azurerm_security_group_sli_id
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "sli"
    subnet_id                     = var.subnet_sli_id
    private_ip_address_allocation = var.azurerm_private_ip_address_allocation
  }
}