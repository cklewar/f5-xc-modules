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
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_site_type_azure" {
  type    = string
  default = "azure"
}

variable "f5xc_site_type_gcp" {
  type    = string
  default = "gcp"
}

variable "f5xc_site_type_aws" {
  type    = string
  default = "aws"
}

variable "f5xc_site_type_vsphere" {
  type    = string
  default = "vmware"
}

variable "f5xc_site_type_k8s" {
  type    = string
  default = "k8s"
}

variable "f5xc_site_type" {
  type = string
  validation {
    condition = contains(["vsphere", "aws", "gcp", "azure", "k8s"], var.f5xc_site_type)
  }
}

variable "f5xc_secure_mesh_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_secure_mesh_site_nodes) == 1 || length(var.f5xc_secure_mesh_site_nodes) == 3
    error_message = "f5xc_secure_mesh_site_nodes must be 1 or 3"
  }
  default = {}
}

variable "f5xc_site_type_certified_hw" {
  type    = map(string)
  default = {
    "aws"     = "aws-voltmesh"
    "gcp"     = "gcp-voltmesh"
    "azure"   = "azure-voltmesh"
    "vsphere" = "vmware-voltmesh"
  }
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_vsphere_site_latitude" {
  type    = number
  default = 37.4
}

variable "f5xc_vsphere_site_longitude" {
  type    = number
  default = -121.9
}

variable "f5xc_token_name" {
  type    = string
  default = ""
}

variable "f5xc_aws_region" {
  type    = string
  default = "us-west-2"
}

variable "f5xc_aws_vpc_az_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_aws_vpc_az_nodes) == 1 || length(var.f5xc_aws_vpc_az_nodes) == 3
    error_message = "f5xc_aws_vpc_az_nodes must be 1 or 3"
  }
  default = {}
}

variable "f5xc_aws_cluster_name" {
  type    = string
  default = ""
}

variable "f5xc_aws_site_latitude" {
  type    = number
  default = 37.4
}

variable "f5xc_aws_site_longitude" {
  type    = number
  default = -121.9
}

variable "f5xc_aws_ce_has_public_ip" {
  type    = bool
  default = true
}

variable "f5xc_vsphere_instance_template" {
  type    = string
  default = ""
}

variable "f5xc_vsphere_cluster_name" {
  type    = string
  default = ""
}

variable "vsphere_instance_outside_interface_default_gateway" {
  type    = string
  default = ""
}

variable "vsphere_instance_outside_interface_default_route" {
  type    = string
  default = ""
}

variable "vsphere_instance_outside_network_name" {
  type    = string
  default = ""
}

variable "vsphere_instance_inside_network_name" {
  type    = string
  default = ""
}

variable "vsphere_dns_servers" {
  type    = map(string)
  default = {
    primary   = "8.8.8.8"
    secondary = "8.8.4.4"
  }
}

variable "vsphere_user" {
  type    = string
  default = ""
}

variable "vsphere_user_password" {
  type    = string
  default = ""
}

variable "vsphere_server" {
  type    = string
  default = ""
}

variable "vsphere_datacenter" {
  type    = string
  default = ""
}

variable "vsphere_cluster" {
  type    = string
  default = ""
}

variable "vsphere_instance_admin_password" {
  type    = string
  default = ""
}

variable "aws_owner" {
  type    = string
  default = ""
}

variable "aws_vpc_cidr_block" {
  type    = string
  default = ""
}

variable "ssh_public_key_file" {
  type = string
}

variable "aws_security_group_rules_slo_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "aws_security_group_rules_slo_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "f5xc_gcp_instance_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_machine_disk_size" {
  type    = string
  default = ""
}

variable "f5xc_gcp_machine_image" {
  type    = string
  default = ""
}

variable "f5xc_gcp_machine_type" {
  type    = string
  default = ""
}

variable "f5xc_gcp_site_latitude" {
  type    = number
  default = 37.4
}

variable "f5xc_gcp_site_longitude" {
  type    = number
  default = -121.9
}

variable "f5xc_gcp_ce_has_public_ip" {
  type    = bool
  default = true
}

variable "gcp_project_name" {
  type    = string
  default = ""
}

variable "gcp_region" {
  type    = string
  default = ""
}

variable "f5xc_azure_site_latitude" {
  type    = number
  default = 37.4
}

variable "f5xc_azure_site_longitude" {
  type    = number
  default = -121.9
}

variable "f5xc_azure_region" {
  type    = string
  default = ""
}

variable "f5xc_azure_ce_has_public_ip" {
  type    = bool
  default = true
}

variable "f5xc_azure_az_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_azure_az_nodes) == 1 || length(var.f5xc_azure_az_nodes) == 3
    error_message = "f5xc_azure_az_nodes must be 1 or 3"
  }
  default = {}
}

variable "f5xc_azure_cluster_name" {
  type    = string
  default = ""
}

variable "azurerm_instance_admin_username" {
  type    = string
  default = ""
}

variable "azurerm_owner" {
  type    = string
  default = ""
}

variable "azurerm_tenant_id" {
  type    = string
  default = ""
}

variable "azurerm_client_id" {
  type    = string
  default = ""
}

variable "azurerm_client_secret" {
  type    = string
  default = ""
}

variable "azurerm_subscription_id" {
  type    = string
  default = ""
}

variable "azurerm_vnet_address_space" {
  type    = list(string)
  default = []
}

variable "azure_security_group_rules_slo" {
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
  default = []
}

