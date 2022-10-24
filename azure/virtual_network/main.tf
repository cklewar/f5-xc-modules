resource "azurerm_virtual_network" "vnet" {
  name                = var.azure_vnet_name
  location            = var.azure_region
  address_space       = [var.azure_vnet_primary_ipv4]
  resource_group_name = var.azure_vnet_resource_group_name
  dns_servers         = var.azure_vnet_dns_servers
  tags                = var.custom_tags

  dynamic "subnet" {
    for_each = length(var.azure_vnet_subnets) > 0 ? var.azure_vnet_subnets : []
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.security_group
    }
  }
}

resource "azurerm_route_table" "rt" {
  count               = length(var.azure_vnet_static_routes) > 0 ? 1 : 0
  location            = azurerm_virtual_network.vnet.location
  name                = format("rt-%s", var.azure_vnet_name)
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_route" "route" {
  for_each            = {for route in var.azure_vnet_static_routes : route.name => route}
  name                = each.value.name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  route_table_name    = azurerm_route_table.rt[0].name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
}