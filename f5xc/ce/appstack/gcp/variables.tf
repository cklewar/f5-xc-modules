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

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
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

variable "f5xc_ce_slo_subnet" {
  type    = string
  default = ""
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["voltstack_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: voltstack_gateway")
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

variable "f5xc_cluster_nodes" {
  type = map(map(map(string)))
  validation {
    condition     = length(var.f5xc_cluster_nodes.master) == 1 && length(var.f5xc_cluster_nodes.worker) == 0 || length(var.f5xc_cluster_nodes.master) == 3 && length(var.f5xc_cluster_nodes.worker) >= 0 || length(var.f5xc_cluster_nodes.master) == 0
    error_message = "Supported master / worker nodes: master 1 and no worker, master 3 and <n> worker"
  }
}

variable "gcp_region" {
  type = string
}

variable "gcp_existing_network_slo" {
  description = "existing gcp compute network name slo"
  type        = string
  default     = null
}

variable "gcp_existing_subnet_network_slo" {
  description = "existing gcp subnet network name slo"
  type        = string
  default     = null
}

variable "gcp_auto_create_subnetworks" {
  type    = bool
  default = false
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

variable "gcp_access_config_nat_ip" {
  type    = string
  default = ""
}

variable "gcp_instance_serial_port_enable" {
  type    = bool
  default = false
}

variable "gcp_instance_tags" {
  type    = list(string)
  default = []
}

variable "gcp_service_account_scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "gcp_service_account_email" {
  type    = string
  default = ""
}

variable "gcp_instance_template_description" {
  type    = string
  default = "F5XC Cloud CE default template"
}

variable "gcp_instance_group_manager_description" {
  type    = string
  default = "F5XC Cloud CE default instance group manager"
}

variable "gcp_instance_template_create_timeout" {
  type    = string
  default = "15m"
}

variable "gcp_instance_template_delete_timeout" {
  type    = string
  default = "15m"
}

variable "gcp_instance_group_manager_wait_for_instances" {
  type    = bool
  default = true
}

variable "gcp_instance_group_manager_base_instance_name" {
  type    = string
  default = "node"
}

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

variable "ssh_username" {
  type    = string
  default = "cloud-user"
}

variable "ssh_public_key" {
  type = string
}

variable "has_public_ip" {
  description = "whether the CE gets a public IP assigned to SLO"
  type        = bool
  default     = true
}