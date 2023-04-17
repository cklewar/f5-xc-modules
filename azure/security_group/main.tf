resource "azurerm_network_security_group" "sg" {
  name                = var.azure_security_group_name
  location            = var.azure_region
  resource_group_name = var.azure_resource_group_name

  dynamic "security_rule" {
    for_each = var.azure_linux_security_rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      source_address_prefix        = security_rule.value.source_address_prefix
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefix   = security_rule.value.destination_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }
  tags = var.custom_tags
}

resource "azurerm_network_interface_security_group_association" "sga" {
  count                     = var.create_interface_security_group_association ? 1 : 0
  network_interface_id      = var.azurerm_network_interface_id
  network_security_group_id = azurerm_network_security_group.sg.id
}