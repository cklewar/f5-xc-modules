locals {
  azurerm_zones = [for z in var.f5xc_cluster_nodes : z["az"] if contains(keys(z), "az")]
  is_multi_nic  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  is_multi_node = length(var.f5xc_cluster_nodes) == 3 ? true : false
  /*slo_snet_ids  = [
    for node in module.network_node : {
      name      = format("%s-slo", node.ce.name)
      subnet_id = node.ce.slo_subnet["id"]
    }
  ]
  sli_snet_ids = local.is_multi_nic ? [
    for node in module.network_node : {
      name      = format("%s-sli", node.ce.name)
      subnet_id = node.ce.sli_subnet["id"]
    }
  ] : []*/
  slo_snet_ids  = [
    for node in module.network_node : {
      name      = format("%s-slo", var.f5xc_cluster_name)
      subnet_id = node.ce.slo_subnet["id"]
    }
  ]
  sli_snet_ids = local.is_multi_nic ? [
    for node in module.network_node : {
      name      = format("%s-sli", var.f5xc_cluster_name)
      subnet_id = node.ce.sli_subnet["id"]
    }
  ] : []
  f5xc_ip_ranges_americas   = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe     = setunion(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia       = setunion(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all        = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP, var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP, var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_azure_resource_group = var.azurerm_existing_resource_group_name != "" ? var.azurerm_existing_resource_group_name : azurerm_resource_group.rg[0].name
  common_tags = {
    # "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner" = var.owner_tag
  }

  azure_security_group_rules_slo_secure_ce = [
    {
      name                       = format("%s-secure-ce-slo-egress-icmp", var.f5xc_cluster_name)
      priority                   = 150
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = format("%s-secure-ce-slo-egress-ntp", var.f5xc_cluster_name)
      priority                   = 151
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                         = format("%s-secure-ces-slo-egress-nat-t", var.f5xc_cluster_name)
      priority                     = 152
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "Udp"
      source_port_range            = "*"
      destination_port_range       = "4500"
      source_address_prefix        = "*"
      destination_address_prefixes = local.f5xc_ip_ranges_all
    },
    {
      name                         = format("%s-secure-ce-slo-egress-https", var.f5xc_cluster_name)
      priority                     = 153
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefix        = "*"
      destination_address_prefixes = var.f5xc_ce_egress_ip_ranges
    },
    {
      name                       = format("%s-secure-ce-slo-ingress-nat-t", var.f5xc_cluster_name)
      priority                   = 154
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "4500"
      source_address_prefixes    = local.f5xc_ip_ranges_all
      destination_address_prefix = "*"
    },
    {
      name                       = format("%s-secure-ce-slo-ingress-ssh", var.f5xc_cluster_name)
      priority                   = 155
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  azure_security_group_rules_sli_secure_ce = [
    {
      name                       = format("%s-secure-ce-sli-egress-icmp", var.f5xc_cluster_name)
      priority                   = 150
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = format("%s-secure-ce-sli-egress-ssh", var.f5xc_cluster_name)
      priority                   = 151
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = format("%s-secure-ce-sli-ingress-ssh", var.f5xc_cluster_name)
      priority                   = 152
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
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

  azure_security_group_rules_sli_default = [
    {
      name                       = format("%s-default-sli-egress", var.f5xc_cluster_name)
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
      name                       = format("%s-default-sli-ingress", var.f5xc_cluster_name)
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