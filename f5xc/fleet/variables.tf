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
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_fleet_name" {
  type = string
}

variable "f5xc_fleet_label" {
  type = string
}

variable "f5xc_no_bond_devices" {
  type    = bool
  default = true
}

variable "f5xc_no_dc_cluster_group" {
  type    = bool
  default = true
}

variable "f5xc_disable_gpu" {
  type    = bool
  default = true
}

variable "f5xc_disable_vm" {
  type    = bool
  default = true
}

variable "f5xc_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_default_storage_class" {
  type    = bool
  default = true
}

variable "f5xc_no_storage_device" {
  type    = bool
  default = true
}

variable "f5xc_no_storage_interfaces" {
  type    = bool
  default = true
}

variable "f5xc_deny_all_usb" {
  type    = bool
  default = true
}

variable "f5xc_enable_default_fleet_config_download" {
  type    = bool
  default = true
}

variable "f5xc_network_connectors" {
  type    = list(string)
  default = []
}

variable "f5xc_outside_virtual_network" {
  type    = list(string)
  default = []
}

variable "f5xc_inside_virtual_network" {
  type    = list(string)
  default = []
}

variable "f5xc_networks_interface_list" {
  type    = list(string)
  default = []
}