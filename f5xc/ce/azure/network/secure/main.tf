resource "azurerm_public_ip_prefix" "nat" {
  sku                 = "Standard"
  name                = format("%s-pip-nat-gateway", var.f5xc_cluster_name)
  zones               = ["1"]
  location            = var.f5xc_azure_region
  ip_version          = "IPv4"
  prefix_length       = 31
  resource_group_name = var.azurerm_resource_group_name
}
resource "azurerm_nat_gateway" "gw" {
  name                    = format("%s-nat-gw", var.f5xc_cluster_name)
  zones                   = ["1"]
  sku_name                = "Standard"
  location                = var.f5xc_azure_region
  resource_group_name     = var.azurerm_resource_group_name
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gw_pip_a" {
  nat_gateway_id      = azurerm_nat_gateway.gw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat.id

}

resource "azurerm_subnet_nat_gateway_association" "sn_nat_gw_a" {
  subnet_id      = var.azurerm_nat_gateway_subnet_id
  nat_gateway_id = azurerm_nat_gateway.gw.id
}