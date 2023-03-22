variable "is_sensitive" {
  type = bool
}

variable "has_public_ip" {
  type = bool
}

variable "owner_tag" {
  type = string
}

variable "azurerm_availability_set_id" {
  type    = string
  default = ""
}

variable "azurerm_instance_vm_size" {
  type    = string
  default = "Standard_F2"
}

variable "azurerm_instance_disk_size" {
  type    = number
  default = 80
}

variable "azurerm_instance_admin_username" {
  type = string
}

variable "azurerm_route_table_next_hop_type" {
  type    = string
  default = "VirtualAppliance"
}

variable "f5xc_site_set_vip_info_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_azure_az_nodes" {
  type = map(map(string))
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
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

variable "f5xc_token_name" {
  type = string
}

variable "f5xc_namespace" {
  type = string
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
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
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

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "f5xc_existing_azure_resource_group" {
  type    = string
  default = ""
}

variable "f5xc_ip_ranges_Americas_TCP" {
  type    = list(string)
  default = ["84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25", "23.158.32.0/25",]
}
variable "f5xc_ip_ranges_Americas_UDP" {
  type    = list(string)
  default = ["23.158.32.0/25", "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25",]
}
variable "f5xc_ip_ranges_Europe_TCP" {
  type    = list(string)
  default = ["84.54.60.0/25", "185.56.154.0/25", "159.60.162.0/24", "159.60.188.0/24", "5.182.212.0/25", "5.182.214.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25",]
}
variable "f5xc_ip_ranges_Europe_UDP" {
  type    = list(string)
  default = ["5.182.212.0/25", "185.56.154.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25", "5.182.214.0/25", "84.54.60.0/25", "159.60.162.0/24", "159.60.188.0/24",]
}
variable "f5xc_ip_ranges_Asia_TCP" {
  type    = list(string)
  default = ["103.135.56.0/25", "103.135.56.128/25", "103.135.58.128/25", "159.60.189.0/24", "159.60.166.0/24", "103.135.57.0/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.164.0/24",]
}
variable "f5xc_ip_ranges_Asia_UDP" {
  type    = list(string)
  default = ["103.135.57.0/25", "103.135.56.128/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.166.0/24", "159.60.164.0/24", "103.135.56.0/25", "103.135.58.128/25", "159.60.189.0/24",]
}

variable "f5xc_ce_egress_ip_ranges" {
  type        = list(string)
  description = "Egress IP ranges for F5 XC CE"
  default     = [
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