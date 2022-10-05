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