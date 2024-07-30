variable "restapi_write_returns_object" {
  type    = bool
  default = true
}

variable "restapi_debug" {
  type    = bool
  default = false
}

variable "f5os_api_schema" {
  type    = string
  default = "https"
}

variable "f5os_api_port" {
  type = number
}

variable "f5os_api_address" {
  type = string
}

variable "f5os_api_base_uri" {
  type    = string
  default = "restconf/data"
}

variable "f5os_api_username" {
  type = string
}

variable "f5os_api_password" {
  type = string
}

variable "f5os_tenant" {
  type = string
}

variable "f5os_tenant_config_type" {
  type    = string
  default = "GENERIC"
}

variable "f5os_tenant_config_nodes" {
  type = list(number)
}

variable "f5os_tenant_config_image" {
  type = string
}

variable "f5os_tenant_config_dag_ipv6_prefix_length" {
  type    = number
  default = 128
}

variable "f5os_tenant_config_dhcp_enabled" {
  type    = bool
  default = true
}

variable "f5os_tenant_config_vlans" {
  type = list(number)
}

variable "f5os_tenant_config_vcpu_cores_per_node" {
  type = number
}

variable "f5os_tenant_config_memory" {
  type = number
}

variable "f5os_tenant_config_storage_size" {
  type = number
}

variable "f5os_tenant_config_l2_inline_mac_block_size" {
  type    = string
  default = "small"
}

variable "f5os_tenant_config_running_state" {
  type    = string
  default = "deployed"
}

variable "f5os_tenant_config_cryptos" {
  type    = string
  default = "enabled"
}

variable "f5os_tenant_config_metadata" {
  type = list(string)
}

variable "f5xc_api_schema" {
  type    = string
  default = "https"
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}