variable "gcp_region" {
  type = string
}

variable "fabric_subnet_outside" {
  type    = string
  default = ""
}

variable "fabric_subnet_inside" {
  type    = string
  default = ""
}

variable "existing_fabric_subnet_inside" {
  type    = string
  default = ""
}

variable "existing_fabric_subnet_outside" {
  type    = string
  default = ""
}

variable "network_name" {
  type    = string
  default = ""
}

variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_image" {
  type = string
}

variable "machine_disk_size" {
  type = string
}

variable "host_localhost_public_name" {
  type    = string
  default = "vip"
}

variable "allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "instance_tags" {
  type    = list(string)
  default = []
}

variable "gcp_service_account_email" {
  type    = string
  default = ""
}

variable "gcp_service_account_scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "access_config_nat_ip" {
  type    = string
  default = ""
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
  default = "centos"
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}

variable "f5xc_ce_slo_firewall" {
  type = object({
    rules = list(object({
      name        = string
      priority    = string
      description = string
      direction   = string
      target_tags = optional(list(string))
      ranges      = list(string)
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
    condition     = alltrue([for elem in var.f5xc_slo_firewall.rules : contains(["INGRESS", "EGRESS"], elem.direction)])
    error_message = "Invalid firewall rule direction"
  }
  default = {
    rules = [
      {
        name        = format("%s-%s-%s-slo-ingress-allow-all", var.network_name, var.instance_name, var.gcp_region)
        priority    = 1000
        description = "DEFAULT SLO INGRESS ALLOW ALL RULE"
        direction   = "INGRESS"
        target_tags = []
        ranges      = [0.0.0.0/0]
        allow       = [
          {
            protocol = "all"
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
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
    condition     = alltrue([for elem in var.f5xc_slo_firewall.rules : contains(["INGRESS", "EGRESS"], elem.direction)])
    error_message = "Invalid firewall rule direction"
  }
  default = {
    rules = [
      {
        name        = format("%s-%s-%s-sli-ingress-allow-all", var.network_name, var.instance_name, var.gcp_region)
        priority    = 1000
        description = "DEFAULT SLI INGRESS ALLOW ALL RULE"
        direction   = "INGRESS"
        target_tags = []
        ranges      = [0.0.0.0/0]
        allow       = [
          {
            protocol = "all"
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }
}

variable "f5xc_cluster_size" {
  type    = number
  default = 1
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

variable "f5xc_ce_gateway_multi_node" {
  type    = bool
  default = false
}

variable "f5xc_cluster_latitude" {
  type = string
}

variable "f5xc_cluster_longitude" {
  type = string
}

variable "f5xc_fleet_label" {
  type = string
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

variable "f5xc_ip_ranges_americas" {
  type        = list(string)
  description = "List of IP ranges to allow ingress/egress for F5 XC CE IPSEC and SSL VPN"
  default     = [
    "5.182.215.0/25",
    "84.54.61.0/25",
    "23.158.32.0/25",
    "84.54.62.0/25",
    "185.94.142.0/25",
    "185.94.143.0/25",
    "159.60.190.0/24",
  ]
}

variable "f5xc_additional_ips" {
  type        = list(string)
  description = "List of additional outbound IP ranges for F5 CE"
  default     = [
    "72.19.3.0/24", # volterra-03
    "20.150.36.4/32", # vesio.blob.core.windows.net
    "20.60.62.4/32", # waferdatasetsprod.blob.core.windows.net
    "18.117.40.234/32", # register.ves.volterra.io
    "13.107.237.0/24", # downloads.volterra.io
    "13.107.238.0/24", # downloads.volterra.io
  ]
}