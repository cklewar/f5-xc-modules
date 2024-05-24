resource "azurerm_public_ip" "ip" {
  count               = var.has_public_ip ? 1 : 0
  sku                 = "Standard"
  name                = "${var.f5xc_node_name}-slo-public-ip"
  zones               = var.azurerm_zone != "" ? [var.azurerm_zone] : null
  location            = var.azurerm_region
  allocation_method   = var.azurerm_public_ip_allocation_method
  resource_group_name = var.azurerm_resource_group_name

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_subnet" "slo" {
  count                = var.azurerm_existing_subnet_name_slo == null && var.azurerm_subnet_slo_address_prefix != null ? 1 : 0
  name                 = format("%s-subnet-slo", var.f5xc_node_name)
  address_prefixes     = [var.azurerm_subnet_slo_address_prefix]
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = var.azurerm_vnet_name
}

resource "azurerm_network_interface" "slo" {
  name                          = "${var.f5xc_node_name}-slo"
  location                      = var.azurerm_region
  resource_group_name           = var.azurerm_resource_group_name
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "slo"
    subnet_id                     = var.azurerm_existing_subnet_name_slo == null ? azurerm_subnet.slo.0.id : data.azurerm_subnet.slo.0.id
    public_ip_address_id          = var.has_public_ip ? azurerm_public_ip.ip.0.id : null
    private_ip_address_allocation = var.azurerm_private_ip_address_allocation_method
  }
}

resource "azurerm_network_interface_security_group_association" "sga_slo" {
  network_interface_id      = azurerm_network_interface.slo.id
  network_security_group_id = var.azurerm_security_group_slo_id
}