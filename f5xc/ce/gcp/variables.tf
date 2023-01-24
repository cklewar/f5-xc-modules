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
  type = string
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
  type = string
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

variable "f5xc_sli_ingress_target_tags" {
  type    = list(string)
  default = []
}

variable "f5xc_sli_egress_target_tags" {
  type    = list(string)
  default = []
}

variable "f5xc_slo_ingress_target_tags" {
  type    = list(string)
  default = []
}

variable "f5xc_slo_egress_target_tags" {
  type    = list(string)
  default = []
}

variable "f5xc_sli_ingress_source_ranges" {
  type    = list(string)
  default = []
}

variable "f5xc_sli_egress_source_ranges" {
  type    = list(string)
  default = []
}

variable "f5xc_slo_ingress_source_ranges" {
  type    = list(string)
  default = []
}

variable "f5xc_slo_egress_source_ranges" {
  type    = list(string)
  default = []
}

variable "f5xc_slo_ingress_allow" {
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = [
    {
      protocol = "all"
    }
  ]
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