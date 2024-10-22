variable "is_sensitive" {
  type = bool
}

variable "wait_for_online" {
  type        = bool
  default     = true
  description = "enable wait_for_online status check. This will wait till CE fully operational"
}

variable "ssh_public_key" {
  type = string
}

variable "has_public_ip" {
  description = "whether the CE gets a public IP assigned to SLO"
  type        = bool
  default     = true
}

variable "owner_tag" {
  type = string
}

variable "status_check_type" {
  type    = string
  default = "token"
  validation {
    condition = contains(["token", "cert"], var.status_check_type)
    error_message = format("Valid values for status_check_type: token or cert")
  }
}

variable "azurerm_availability_set_id" {
  type    = string
  default = ""
}

variable "azurerm_vnet_address_space" {
  type = list(string)
  default = []
}

variable "azurerm_instance_vm_size" {
  type = string
}

variable "azurerm_instance_disk_size" {
  type    = number
  default = 80
}

variable "azurerm_instance_admin_username" {
  type = string
}

variable "azurerm_instance_admin_password" {
  type    = string
  default = ""
}

variable "azurerm_route_table_next_hop_type" {
  type    = string
  default = "VirtualAppliance"
}

variable "azurerm_tenant_id" {
  type = string
}

variable "azurerm_subscription_id" {
  type = string
}

variable "azurerm_client_id" {
  type = string
}

variable "azurerm_client_secret" {
  type = string
}

variable "azurerm_marketplace_version" {
  type    = string
  default = "latest"
}

variable "azure_security_group_rules_slo" {
  type = list(object({
    name                   = string
    priority               = number
    direction              = string
    access                 = string
    protocol               = string
    source_port_range      = string
    destination_port_range = string
    source_address_prefix = optional(string)
    source_address_prefixes = optional(list(string))
    destination_address_prefix = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
}

variable "azure_security_group_rules_sli" {
  type = list(object({
    name                   = string
    priority               = number
    direction              = string
    access                 = string
    protocol               = string
    source_port_range      = string
    destination_port_range = string
    source_address_prefix = optional(string)
    source_address_prefixes = optional(list(string))
    destination_address_prefix = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
}

variable "azure_security_group_rules_slo_ingress_default" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "azure_security_group_rules_sli_egress_default" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "azure_security_group_rules_sli_ingress_default" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "f5xc_is_secure_cloud_ce" {
  type    = bool
  default = false
}

variable "f5xc_is_private_cloud_ce" {
  type    = bool
  default = false
}

variable "f5xc_enable_offline_survivability_mode" {
  type    = bool
  default = false
}

variable "f5xc_ce_performance_enhancement_mode" {
  type = object({
    perf_mode_l7_enhanced = bool
    perf_mode_l3_enhanced = optional(object({
      jumbo_frame_enabled = bool
    }))
  })
  default = {
    perf_mode_l7_enhanced = true
  }
}

variable "f5xc_azure_marketplace_agreement_offers" {
  type = map(string)
  default = {
    app_stack              = "entcloud_voltmesh_voltstack_node"
    ingress_gateway        = "volterra-node"
    ingress_egress_gateway = "entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_azure_marketplace_agreement_plans" {
  type = map(string)
  default = {
    app_stack              = "freeplan_entcloud_voltmesh_voltstack_node"
    ingress_gateway        = "volterra-node"
    ingress_egress_gateway = "freeplan_entcloud_voltmesh_voltstack_node_multinic"
  }
}

variable "azurerm_existing_vnet_name" {
  description = "Azure existing vnet name"
  type        = string
  default     = ""
}

variable "azurerm_existing_resource_group_name" {
  description = "Azure existing resource group name"
  type        = string
  default     = ""
}

variable "azurerm_disable_password_authentication" {
  type    = bool
  default = true
}

variable "azurerm_os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "f5xc_azure_marketplace_agreement_publisher" {
  type    = string
  default = "volterraedgeservices"
}

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
}

variable "f5xc_site_set_vip_info_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_cluster_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_cluster_nodes) == 1 || length(var.f5xc_cluster_nodes) == 3
    error_message = "f5xc_cluster_nodes must be 1 or 3"
  }
}

variable "f5xc_ce_slo_secondary_ips" {
  description = "Used to initialise secondary IPs on SLO interface"
  type = list(object({
    ip   = string
    name = string
  }))
  default = []
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_cluster_latitude" {
  description = "geo latitude"
  type        = number
  default     = -73.935242
}

variable "f5xc_cluster_longitude" {
  description = "geo longitude"
  type        = number
  default     = 40.730610
}

variable "f5xc_api_p12_file" {
  description = "F5 XC api ca cert"
  type        = string
  default     = ""
}

variable "f5xc_api_url" {
  description = "F5 XC tenant api URL"
  type        = string
}

variable "f5xc_api_token" {
  description = "F5 XC api token"
  type        = string
  default     = ""
}

variable "f5xc_tenant" {
  description = "F5 XC tenant"
  type        = string
}

variable "f5xc_token_name" {
  description = "F5 XC api token name"
  type        = string
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_ce_gateway_type_voltstack" {
  type    = string
  default = "voltstack_gateway"
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition = contains(["ingress_egress_gateway", "ingress_gateway", "voltstack_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway, voltstack_gateway")
  }
}

variable "f5xc_ce_to_re_tunnel_type" {
  description = "CE to RE tunnel type"
  type        = string
  validation {
    condition = contains(["ssl", "ipsec"], var.f5xc_ce_to_re_tunnel_type)
    error_message = format("Valid values for tunnel_type: ssl, ipsec")
  }
  default = "ipsec"
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_cluster_name" {
  type = string
}

variable "azurerm_region" {
  type = string
}

variable "f5xc_cluster_default_blocked_services" {
  type    = bool
  default = false
}

variable "f5xc_api_p12_cert_password" {
  description = "XC API cert file password used later in status module to retrieve site status"
  type        = string
  default     = ""
}

variable "f5xc_secure_mesh_site_version" {
  type    = number
  default = 2
  validation {
    condition = contains([1, 2], var.f5xc_secure_mesh_site_version)
    error_message = "f5xc_secure_mesh_site_version must be 1 or 2"
  }
}

variable "f5xc_sms_provider_name" {
  type    = string
  default = null
}

variable "f5xc_sms_master_nodes_count" {
  type    = number
  default = 1
}

variable "f5xc_is_legacy_ce" {
  type    = bool
  default = false
}

variable "f5xc_ip_ranges_Americas_TCP" {
  type = list(string)
  default = [
    "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25",
    "23.158.32.0/25",
  ]
}
variable "f5xc_ip_ranges_Americas_UDP" {
  type = list(string)
  default = [
    "23.158.32.0/25", "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25",
    "84.54.61.0/25",
  ]
}
variable "f5xc_ip_ranges_Europe_TCP" {
  type = list(string)
  default = [
    "84.54.60.0/25", "185.56.154.0/25", "159.60.162.0/24", "159.60.188.0/24", "5.182.212.0/25", "5.182.214.0/25",
    "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25",
  ]
}
variable "f5xc_ip_ranges_Europe_UDP" {
  type = list(string)
  default = [
    "5.182.212.0/25", "185.56.154.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25", "5.182.214.0/25",
    "84.54.60.0/25", "159.60.162.0/24", "159.60.188.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_TCP" {
  type = list(string)
  default = [
    "103.135.56.0/25", "103.135.56.128/25", "103.135.58.128/25", "159.60.189.0/24", "159.60.166.0/24",
    "103.135.57.0/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.164.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_UDP" {
  type = list(string)
  default = [
    "103.135.57.0/25", "103.135.56.128/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.166.0/24", "159.60.164.0/24",
    "103.135.56.0/25", "103.135.58.128/25", "159.60.189.0/24",
  ]
}

variable "f5xc_ce_egress_ip_ranges" {
  type = list(string)
  description = "Egress IP ranges for F5 XC CE"
  default = [
    "20.33.0.0/16",
    "74.125.0.0/16",
    "18.64.0.0/10",
    "52.223.128.0/18",
    "20.152.0.0/15",
    "13.107.238.0/24",
    "142.250.0.0/15",
    "20.34.0.0/15",
    "52.192.0.0/12",
    "52.208.0.0/13",
    "52.223.0.0/17",
    "18.32.0.0/11",
    "3.208.0.0/12",
    "13.107.237.0/24",
    "20.36.0.0/14",
    "52.222.0.0/16",
    "52.220.0.0/15",
    "3.0.0.0/9",
    "100.64.0.0/10",
    "54.88.0.0/16",
    "52.216.0.0/14",
    "108.177.0.0/17",
    "20.40.0.0/13",
    "54.64.0.0/11",
    "172.253.0.0/16",
    "20.64.0.0/10",
    "20.128.0.0/16",
    "172.217.0.0/16",
    "173.194.0.0/16",
    "20.150.0.0/15",
    "20.48.0.0/12",
    "72.19.3.0/24",
    "18.128.0.0/9",
    "23.20.0.0/14",
    "13.104.0.0/14",
    "13.96.0.0/13",
    "13.64.0.0/11",
    "13.249.0.0/16",
    "34.192.0.0/10",
    "3.224.0.0/12",
    "54.208.0.0/13",
    "54.216.0.0/14",
    "108.156.0.0/14",
    "54.144.0.0/12",
    "54.220.0.0/15",
    "54.192.0.0/12",
    "54.160.0.0/11",
    "52.88.0.0/13",
    "52.84.0.0/14",
    "52.119.128.0/17",
    "54.240.192.0/18",
    "52.94.208.0/21"
  ]
}