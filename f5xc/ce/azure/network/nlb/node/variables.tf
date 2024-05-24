variable "is_multi_nic" {
  type = bool
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_cluster_name" {
  type = string
}

/*variable "azurerm_lb_id" {
  type = string
}

variable "azurerm_lb_probe_id_slo" {
  type = string
}

variable "azurerm_lb_probe_id_sli" {
  type = string
}*/

variable "azurerm_network_interface_slo_id" {
  type = string
}

variable "azurerm_network_interface_sli_id" {
  type = string
}

variable "azurerm_backend_address_pool_id_slo" {
  type = string
}

variable "azurerm_backend_address_pool_id_sli" {
  type = string
}