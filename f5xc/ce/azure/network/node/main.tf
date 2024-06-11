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
  name = format("%s-subnet-slo", var.f5xc_node_name)
  address_prefixes = [var.azurerm_subnet_slo_address_prefix]
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = var.azurerm_vnet_name
}

resource "azurerm_subnet" "sli" {
  count                = var.is_multi_nic && var.azurerm_existing_subnet_name_sli == null && var.azurerm_subnet_sli_address_prefix != null ? 1 : 0
  name = format("%s-subnet-sli", var.f5xc_node_name)
  address_prefixes = [var.azurerm_subnet_sli_address_prefix]
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = var.azurerm_vnet_name

  /*lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }*/
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

  dynamic "ip_configuration" {
    for_each = var.f5xc_ce_slo_secondary_ips
    content {
      name                          = format("lb-%s", ip_configuration.value.name)
      subnet_id                     = var.azurerm_existing_subnet_name_slo == null ? azurerm_subnet.slo.0.id : data.azurerm_subnet.slo.0.id
      private_ip_address_allocation = "Static"
      private_ip_address            = ip_configuration.value.ip
    }
  }
}

resource "azurerm_network_interface" "sli" {
  count                         = var.is_multi_nic ? 1 : 0
  name                          = "${var.f5xc_node_name}-sli"
  location                      = var.azurerm_region
  resource_group_name           = var.azurerm_resource_group_name
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "sli"
    subnet_id                     = var.azurerm_existing_subnet_name_sli == null ? azurerm_subnet.sli.0.id : data.azurerm_subnet.sli.0.id
    private_ip_address_allocation = var.azurerm_private_ip_address_allocation_method
  }
}

resource "azurerm_route_table" "sli" {
  count               = var.is_multi_nic ? 1 : 0
  name = format("%s-sli-rt", var.f5xc_node_name)
  location            = var.azurerm_region
  resource_group_name = var.azurerm_resource_group_name

  dynamic "route" {
    for_each = var.azurerm_existing_subnet_name_sli == null ? [1] : []
    content {
      name = format("%s-sli-default-route", var.f5xc_node_name)
      address_prefix = "0.0.0.0/0"
      next_hop_type  = var.azurerm_route_table_next_hop_type
      next_hop_in_ip_address = cidrhost(azurerm_subnet.sli.0.address_prefixes[0], 1)
    }
  }
}

resource "azurerm_subnet_route_table_association" "sli" {
  count          = var.is_multi_nic && var.azurerm_existing_subnet_name_sli == null ? 1 : 0
  subnet_id      = azurerm_subnet.sli.0.id
  route_table_id = azurerm_route_table.sli.0.id
}

resource "azurerm_network_interface_security_group_association" "sga_slo" {
  network_interface_id      = azurerm_network_interface.slo.id
  network_security_group_id = var.azurerm_security_group_slo_id
}

resource "azurerm_network_interface_security_group_association" "sga_sli" {
  count                     = var.is_multi_nic ? 1 : 0
  network_interface_id      = azurerm_network_interface.sli.0.id
  network_security_group_id = var.azurerm_security_group_sli_id
}