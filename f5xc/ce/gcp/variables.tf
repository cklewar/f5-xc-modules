variable "owner" {
  type = string
}

variable "status_check_type" {
  type    = string
  default = "token"
  validation {
    condition     = contains(["token", "cert"], var.status_check_type)
    error_message = format("Valid values for status_check_type: token or cert")
  }
}

variable "has_public_ip" {
  type        = bool
  default     = true
  description = "Whether to include the access_config{} into the instance, adding a public Internet IP address, otherwise use NAT."
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "cloud-user"
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}

variable "gcp_region" {
  type = string
}

variable "gcp_project_id" {
  description = "GCP account project id"
  type        = string
}

variable "gcp_instance_serial_port_enable" {
  type    = bool
  default = false
}

variable "gcp_existing_network_slo" {
  description = "existing gcp compute network name slo"
  type        = string
  default     = null
}

variable "gcp_existing_network_sli" {
  description = "existing gcp compute network name sli"
  type        = string
  default     = null
}

variable "gcp_existing_subnet_network_slo" {
  description = "existing gcp subnet network name slo"
  type        = string
  default     = null
}

variable "gcp_existing_subnet_network_sli" {
  description = "existing gcp subnet network name sli"
  type        = string
  default     = null
}

variable "gcp_instance_type" {
  type    = string
  default = "n2-standard-8"
}

variable "gcp_instance_image" {
  type = string
}

variable "gcp_instance_disk_size" {
  type    = string
  default = "40"
}

variable "gcp_instance_template_description" {
  type    = string
  default = "F5XC Cloud CE default template"
}

variable "gcp_instance_group_manager_description" {
  type    = string
  default = "F5XC Cloud CE default instance group manager"
}

variable "gcp_instance_group_manager_wait_for_instances" {
  type    = bool
  default = true
}

variable "gcp_instance_group_manager_base_instance_name" {
  type    = string
  default = "node"
}

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
}

variable "f5xc_ce_hosts_public_address" {
  type    = string
  default = "127.0.1.1"
}

variable "gcp_allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "gcp_instance_tags" {
  type    = list(string)
  default = []
}

variable "gcp_instance_template_create_timeout" {
  type    = string
  default = "15m"
}

variable "gcp_instance_template_delete_timeout" {
  type    = string
  default = "15m"
}

variable "gcp_service_account_email" {
  type    = string
  default = ""
}

variable "gcp_service_account_scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "gcp_auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "gcp_access_config_nat_ip" {
  type    = string
  default = ""
}

variable "f5xc_site_type_is_secure_mesh_site" {
  type    = bool
  default = true
}

variable "f5xc_private_ce_nat_name" {
  type        = string
  default     = null
  description = "private ce creates gcp nat object. this object needs a name"
}

variable "f5xc_private_ce_nat_router_name" {
  type        = string
  default     = null
  description = "private ce module creates gcp router object. this object needs a name"
}

variable "f5xc_ce_slo_firewall" {
  type = object({
    rules = list(object({
      name        = string
      priority    = string
      description = string
      direction   = string
      target_tags = optional(list(string))
      ranges      = optional(list(string))
      allow       = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      deny = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      log_config = optional(object({
        metadata = string
      }))
    }))
  })
  validation {
    condition     = alltrue([for elem in var.f5xc_ce_slo_firewall.rules : contains(["INGRESS", "EGRESS"], lookup(elem, "direction", null))])
    error_message = "Invalid firewall rule direction"
  }
  default = {
    rules = []
  }
}

variable "f5xc_ce_sli_firewall" {
  type = object({
    rules = list(object({
      name        = string
      priority    = string
      description = string
      direction   = string
      target_tags = optional(list(string))
      ranges      = optional(list(string))
      allow       = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      deny = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      log_config = optional(object({
        metadata = string
      }))
    }))
  })
  validation {
    condition     = alltrue([for elem in var.f5xc_ce_sli_firewall.rules : contains(["INGRESS", "EGRESS"], lookup(elem, "direction", null))])
    error_message = "Invalid firewall rule direction"
  }
  default = {
    rules = []
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

variable "f5xc_cluster_latitude" {
  type    = string
  default = -73.935242
}

variable "f5xc_cluster_longitude" {
  type    = string
  default = 40.730610
}

variable "f5xc_cluster_labels" {
  type = map(string)
  default = {}
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_ce_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_ce_nodes) == 1 || length(var.f5xc_ce_nodes) == 3 || length(var.f5xc_ce_nodes) == 0
    error_message = "f5xc_ce_nodes must be 0,1 or 3"
  }
}

variable "f5xc_ce_slo_subnet" {
  type    = string
  default = ""
}

variable "f5xc_ce_sli_subnet" {
  type    = string
  default = ""
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_p12_file" {
  description = "F5 XC api ca cert"
  type        = string
  default     = ""
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

variable "f5xc_api_p12_cert_password" {
  description = "XC API cert file password used later in status module to retrieve site status"
  type        = string
  default     = ""
}

variable "f5xc_is_secure_cloud_ce" {
  description = "whether CE should be secured by applying security rules on SLO and SLI + NAT GW + SLO private IP"
  type        = bool
  default     = false
}

variable "f5xc_is_private_cloud_ce" {
  description = "whether CE should be private with SLO has private IP and NAT GW in front"
  type        = bool
  default     = false
}

variable "f5xc_ce_slo_enable_secure_sg" {
  description = "whether CE should be secured by applying security rules on SLO"
  type        = bool
  default     = false
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