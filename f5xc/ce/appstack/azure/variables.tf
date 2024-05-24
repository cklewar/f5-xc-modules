variable "is_sensitive" {
  description = "mark module output as sensitive"
  type        = bool
}

variable "status_check_type" {
  type    = string
  default = "token"
  validation {
    condition     = contains(["token", "cert"], var.status_check_type)
    error_message = format("Valid values for status_check_type: token or cert")
  }
}

variable "ssh_public_key" {
  type = string
}

variable "has_public_ip" {
  type = bool
}

variable "owner_tag" {
  type = string
}

variable "f5xc_tenant" {
  description = "F5 XC tenant"
  type        = string
}

variable "f5xc_api_url" {
  description = "F5 XC tenant api URL"
  type        = string
}

variable "f5xc_api_token" {
  description = "F5 XC api token"
  type        = string
}

variable "f5xc_token_name" {
  description = "F5 XC api token name"
  type        = string
  default     = ""
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_cluster_name" {
  description = "F5XC Site / Cluster name"
  type        = string
}

variable "f5xc_api_p12_file" {
  description = "F5 XC api ca cert"
  type        = string
  default     = ""
}

variable "f5xc_api_p12_cert_password" {
  description = "XC API cert file password used later in status module to retrieve site status"
  type        = string
  default     = ""
}

variable "f5xc_ce_gateway_type_voltstack" {
  type    = string
  default = "voltstack_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["voltstack_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: voltstack_gateway")
  }
}

variable "azurerm_vnet_address_space" {
  type    = list(string)
  default = []
}

variable "azurerm_availability_set_id" {
  type    = string
  default = ""
}

variable "azurerm_route_table_next_hop_type" {
  type    = string
  default = "VirtualAppliance"
}

variable "azurerm_security_group_rules_slo" {
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = string
    destination_port_range       = string
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
}

variable "f5xc_cluster_nodes" {
  type = map(map(map(string)))
  validation {
    condition     = length(var.f5xc_cluster_nodes.master) == 1 && length(var.f5xc_cluster_nodes.worker) == 0 || length(var.f5xc_cluster_nodes.master) == 3 && length(var.f5xc_cluster_nodes.worker) >= 0 || length(var.f5xc_cluster_nodes.master) == 0
    error_message = "Supported master / worker nodes: master 1 and no worker, master 3 and <n> worker"
  }
}

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
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

variable "azurerm_region" {
  type = string
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

variable "azurerm_subscription_id" {
  type = string
}

variable "azurerm_client_id" {
  type = string
}

variable "azurerm_client_secret" {
  type = string
}

variable "azurerm_tenant_id" {
  type = string
}

variable "azurerm_instance_admin_username" {
  type = string
}

variable "azurerm_instance_vm_size" {
  type    = string
  default = "Standard_D3_v2"
}

variable "azurerm_instance_disk_size" {
  type    = number
  default = 80
}

variable "f5xc_azure_marketplace_agreement_offers" {
  type = map(string)
  default = {
    ingress_gateway        = "volterra-node"
    voltstack_gateway      = "entcloud_voltmesh_voltstack_node"
    ingress_egress_gateway = "entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_azure_marketplace_agreement_plans" {
  type = map(string)
  default = {
    ingress_gateway        = "volterra-node"
    voltstack_gateway      = "freeplan_entcloud_voltmesh_voltstack_node"
    ingress_egress_gateway = "freeplan_entcloud_voltmesh_voltstack_node_multinic"
  }
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "azurerm_marketplace_version" {
  type    = string
  default = "latest"
}

variable "f5xc_azure_marketplace_agreement_publisher" {
  type    = string
  default = "volterraedgeservices"
}

variable "azurerm_instance_admin_password" {
  type    = string
  default = ""
}

variable "azurerm_disable_password_authentication" {
  type    = bool
  default = true
}

variable "azurerm_os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}