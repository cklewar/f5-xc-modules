resource "azurerm_public_ip" "ip" {
  count               = var.has_public_ip ? 1 : 0
  name                = "${var.f5xc_node_name}-slo-public-ip"
  location            = var.f5xc_azure_region
  resource_group_name = var.azurerm_resource_group_name
  allocation_method   = var.azurerm_public_ip_allocation_method
}

resource "azurerm_network_interface" "slo" {
  name                          = "${var.f5xc_node_name}-slo"
  location                      = var.f5xc_azure_region
  resource_group_name           = var.azurerm_resource_group_name
  network_security_group_id     = var.azurerm_security_group_slo_id
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "slo"
    subnet_id                     = var.subnet_slo_id
    private_ip_address_allocation = var.azurerm_private_ip_address_allocation
    public_ip_address_id          = var.has_public_ip ? var.f5xc_ce_public_ip_id : null
  }
}

resource "azurerm_network_interface" "sli" {
  count                         = var.is_multi_nic ? 1 : 0
  name                          = "${var.f5xc_node_name}-sli"
  location                      = var.f5xc_azure_region
  resource_group_name           = var.azurerm_resource_group_name
  network_security_group_id     = var.azurerm_security_group_sli_id
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "sli"
    subnet_id                     = var.subnet_sli_id
    private_ip_address_allocation = var.azurerm_private_ip_address_allocation
  }
}

resource "azurerm_subnet" "slo" {
  name                      = "subnet-${var.f5xc_node_name}-slo"
  virtual_network_name      = var.azurerm_vnet_name
  resource_group_name       = var.azurerm_resource_group_name
  network_security_group_id = var.azurerm_security_group_slo_id
  address_prefixes          = []
}

resource "azurerm_subnet" "sli" {
  count                     = var.is_multi_nic ? 1 : 0
  name                      = "subnet-${var.f5xc_node_name}-sli"
  virtual_network_name      = var.azurerm_vnet_name
  resource_group_name       = var.azurerm_resource_group_name
  network_security_group_id = var.azurerm_security_group_sli_id
  lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }
  address_prefixes = []
}

resource "azurerm_route_table" "sli" {
  count               = var.is_multi_nic ? 1 : 0
  name                = format("%s-sli-rt", var.f5xc_node_name)
  location            = var.f5xc_azure_region
  resource_group_name = var.azurerm_resource_group_name

  route {
    name                   = format("%s-sli-default-route", var.f5xc_node_name)
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = var.azurerm_route_table_next_hop_type
    next_hop_in_ip_address = element(values(element(var.sli_subnet_ip_addr_map, count.index)), 0)
  }
}

resource "azurerm_subnet_route_table_association" "sli" {
  count          = var.is_multi_nic ? 1 : 0
  subnet_id      = element(keys(element(var.sli_subnet_ip_addr_map, count.index)), 0)
  route_table_id = azurerm_route_table.sli.*.id
}

resource "azurerm_network_interface_backend_address_pool_association" "slo" {
  network_interface_id    = azurerm_network_interface.slo.id
  ip_configuration_name   = format("%s-ip-cfg", var.f5xc_node_name)
  backend_address_pool_id = var.azurerm_backend_address_pool_id
}