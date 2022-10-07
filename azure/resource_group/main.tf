resource "azurerm_resource_group" "rg" {
  name     = var.azure_resource_group_name
  location = var.azure_region
  tags     = var.custom_tags
}