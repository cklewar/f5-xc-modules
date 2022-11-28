variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_key" {
  type    = string
  default = ""
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_file" {
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

variable "f5xc_interface_type_tunnel_interface" {
  type    = string
  default = "tunnel_interface"
}

variable "f5xc_interface_type_ethernet_interface" {
  type    = string
  default = "ethernet_interface"
}

variable "f5xc_interface_type_dedicated_management_interface" {
  type    = string
  default = "dedicated_management_interface"
}

variable "f5xc_interface_type_dedicated_interface" {
  type    = string
  default = "dedicated_interface"
}

variable "f5xc_interface_type" {
  type = string

  validation {
    condition = contains([
      "ethernet_interface", "dedicated_management_interface", "dedicated_interface", "tunnel_interface"
    ], var.f5xc_interface_type)
    error_message = "Allowed values for input_parameter are 'ethernet_interface', 'dedicated_management_interface', 'dedicated_interface', 'tunnel_interface'."
  }
}

variable "f5xc_interface_name" {
  type = string
}

variable "f5xc_tunnel_name" {
  type    = string
  default = ""
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_interface_static_ip" {
  type = string
}

variable "f5xc_interface_site_local_network" {
  type    = bool
  default = true
}

variable "f5xc_interface_dhcp_server_automatic_from_start" {
  type    = bool
  default = true
}

variable "f5xc_interface_dhcp_server_automatic_from_end" {
  type    = bool
  default = false
}

variable "f5xc_interface_dhcp_server_interface_ip_map" {
  type    = map(string)
  default = {}
  /*{
    "master-0" = "10.0.0.1"
    "master-1" = "10.0.0.2"
    "master-2" = "10.0.0.3"
  }*/
}

variable "f5xc_interface_inside_network" {
  type    = string
  default = ""
}

variable "f5xc_apply_to_cluster" {
  type    = bool
  default = true
}

variable "f5xc_apply_to_node" {
  type    = string
  default = ""
}

variable "f5xc_interface_default_gw" {
  type    = string
  default = ""
}

variable "f5xc_interface_dhcp_server_networks" {
  type = list(object({
    network_prefix           = string
    dns_address              = optional(string)
    same_as_dgw              = optional(bool)
    dgw_address              = optional(string)
    first_address            = optional(bool)
    last_address             = optional(bool)
    network_prefix_allocator = object({
      name      = string
      namespace = string
      tenant    = string
    })
    pool_settings = string
    pools         = list(object({
      exclude  = bool
      start_ip = string
      end_ip   = string
    }))
  }))
  default = []
}

variable "f5xc_interface_static_ip_interface_ip_map" {
  type        = string
  default     = ""
  description = "Site:Node to IP address"
}

variable "f5xc_interface_static_ip_node_static_ip" {
  type    = string
  default = ""
}

variable "f5xc_interface_dns_server" {
  type    = string
  default = ""
}

variable "f5xc_interface_site_local_inside_network" {
  type    = bool
  default = false
}

variable "f5xc_interface_inside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_interface_no_ipv6_address" {
  type    = bool
  default = true
}

variable "f5xc_interface_dhcp_client" {
  type    = bool
  default = false
}

variable "f5xc_interface_dhcp_networks_pools" {
  type = list(object({
    exclude  = bool
    start_ip = string
    end_ip   = string
  }))
  default = []
}

variable "f5xc_interface_monitor_disabled" {
  type    = bool
  default = true
}

variable "f5xc_interface_dhcp_networks_pool_settings" {
  type    = string
  default = "INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS"

  validation {
    condition = contains([
      "INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS", "EXCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS"
    ], var.f5xc_interface_dhcp_networks_pool_settings)
    error_message = "Allowed values for input_parameter are 'INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS', 'EXCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS'."
  }
}

variable "f5xc_tunnel_interface_template_file" {
  type    = string
  default = "interface.tftpl"
}

variable "f5xc_interface_description" {
  type    = string
  default = ""
}

variable "f5xc_interface_create_uri" {
  type    = string
  default = "config/namespaces/%s/network_interfaces"
}

variable "f5xc_interface_delete_uri" {
  type    = string
  default = "config/namespaces/%s/network_interfaces"
}

variable "f5xc_interface_payload_file" {
  type    = string
  default = "interface.json"
}

variable "f5xc_interface_mtu" {
  type    = string
  default = null
}

variable "f5xc_interface_priority" {
  type    = number
  default = null
}

variable "f5xc_interface_untagged" {
  type    = bool
  default = true
}

variable "f5xc_interface_vlan_id" {
  type    = number
  default = null
}

variable "f5xc_interface_is_primary" {
  type    = bool
  default = false
}

variable "f5xc_interface_not_primary" {
  type    = bool
  default = true
}

variable "f5xc_interface_dhcp_server_fixed_ip_map" {
  type    = map(string)
  default = {}
  /*
  {
    "00:00:00:00:FF": "10.0.0.100",
    "00:00:00:00:EE": "10.0.0.101"
  }
  */
}

variable "f5xc_interface_dhcp_option82_tag" {
  type    = string
  default = ""
}

variable "f5xc_interface_ethernet_interface_device" {
  type    = string
  default = "eth0"
}

variable "f5xc_labels" {
  type    = map(string)
  default = {}
}