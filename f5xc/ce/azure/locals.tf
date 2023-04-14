locals {
  is_multi_nic              = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  is_multi_node             = length(var.f5xc_azure_az_nodes) == 3 ? true : false
  f5xc_ip_ranges_americas   = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe     = setunion(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia       = setunion(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all        = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP, var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP, var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_azure_resource_group = var.f5xc_existing_azure_resource_group != "" ? var.f5xc_existing_azure_resource_group : azurerm_resource_group.rg[0].name
  common_tags               = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }

  azure_security_group_rules_slo_secure_ce = [
    {
      name                       = "SECURE CE SLO EGRESS ICMP"
      priority                   = 150
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "SECURE CE SLO EGRESS NTP"
      priority                   = 151
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                         = "SECURE CE SLO EGRESS NAT-T"
      priority                     = 152
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "udp"
      source_port_range            = "*"
      destination_port_range       = "4500"
      source_address_prefix        = "*"
      destination_address_prefixes = local.f5xc_ip_ranges_all
    },
    {
      name                         = "SECURE CE SLO EGRESS HTTPS"
      priority                     = 153
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefix        = "*"
      destination_address_prefixes = local.f5xc_ip_ranges_all
    },
    {
      name                       = "SECURE CE SLO INGRESS NAT-T"
      priority                   = 154
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "udp"
      source_port_range          = "*"
      destination_port_range     = "4500"
      source_address_prefixes    = local.f5xc_ip_ranges_all
      destination_address_prefix = "*"
    },
    {
      name                       = "SECURE CE SLO INGRESS SSH"
      priority                   = 155
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  azure_security_group_rules_sli_secure_ce = [
    {
      name                       = "SECURE CE SLI EGRESS ICMP"
      priority                   = 150
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "SECURE CE SLI EGRESS SSH"
      priority                   = 151
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "SECURE CE SLI INGRESS SSH"
      priority                   = 152
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}