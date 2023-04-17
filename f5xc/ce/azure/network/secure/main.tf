resource "azurerm_public_ip_prefix" "nat" {
  sku                 = "Standard"
  name                = format("%s-pip-nat-gateway", var.f5xc_cluster_name)
  zones               = var.f5xc_secure_ce_zones
  location            = var.f5xc_azure_region
  ip_version          = "IPv4"
  prefix_length       = var.azurerm_public_ip_prefix_prefix_length
  resource_group_name = var.azurerm_resource_group_name
}
resource "azurerm_nat_gateway" "gw" {
  name                    = format("%s-nat-gw", var.f5xc_cluster_name)
  zones                   = var.f5xc_secure_ce_zones
  sku_name                = "Standard"
  location                = var.f5xc_azure_region
  resource_group_name     = var.azurerm_resource_group_name
  idle_timeout_in_minutes = var.azurerm_nat_gateway_idle_timeout_in_minutes
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gw_pip_a" {
  nat_gateway_id      = azurerm_nat_gateway.gw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "sn_nat_gw_a" {
  subnet_id      = var.azurerm_nat_gateway_subnet_id
  nat_gateway_id = azurerm_nat_gateway.gw.id
}

resource "azurerm_network_interface_security_group_association" "sga_slo_secure_ce" {
  network_interface_id      = var.azurerm_network_interface_slo_id
  network_security_group_id = var.azurerm_security_group_slo_id
}

resource "azurerm_network_interface_security_group_association" "sga_sli_secure_ce" {
  count                     = var.is_multi_nic ? 1 : 0
  network_interface_id      = var.azurerm_network_interface_sli_id
  network_security_group_id = var.azurerm_security_group_sli_id
}