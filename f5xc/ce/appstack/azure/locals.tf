locals {
  common_tags = {
    "Owner" = var.owner_tag
  }
  f5xc_azure_resource_group              = var.azurerm_existing_resource_group_name != "" ? var.azurerm_existing_resource_group_name : azurerm_resource_group.rg[0].name
  azure_security_group_rules_slo_default = [
    {
      name                       = format("%s-default-slo-egress", var.f5xc_cluster_name)
      priority                   = 150
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = format("%s-default-slo-ingress", var.f5xc_cluster_name)
      priority                   = 151
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}