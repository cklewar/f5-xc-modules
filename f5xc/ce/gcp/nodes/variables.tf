variable "f5xc_ce_user_data" {
  type = string
}

variable "f5xc_cluster_size" {
  type = number
}

variable "f5xc_registration_wait_time" {
  type = number
}

variable "f5xc_registration_retry" {
  type = number
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
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_labels" {
  type = map(string)
  default = {}
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}

variable "gcp_instance_type" {
  type = string
}

variable "gcp_instance_image" {
  type = string
}

variable "gcp_instance_disk_size" {
  type = string
}

variable "gcp_instance_template_description" {
  type = string
}

variable "gcp_instance_template_create_timeout" {
  type = string
}

variable "gcp_instance_template_delete_timeout" {
  type = string
}

variable "gcp_instance_group_manager_description" {
  type = string
}

variable "gcp_instance_group_manager_distribution_policy_zones" {
  type = list(string)
}

variable "gcp_instance_group_manager_wait_for_instances" {
  type = bool
}

variable "gcp_instance_group_manager_base_instance_name" {
  type = string
}

variable "gcp_instance_tags" {
  type = list(string)
}

variable "gcp_region" {
  type = string
}

variable "gcp_service_account_email" {
  type = string
}

variable "gcp_service_account_scopes" {
  type = list(string)
}

variable "gcp_access_config_nat_ip" {
  type = string
}

variable "gcp_instance_serial_port_enable" {
  type = bool
}

variable "gcp_instance_can_ip_forward" {
  type    = bool
  default = true
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "has_public_ip" {
  type = bool
}

variable "is_sensitive" {
  type = bool
}

variable "gcp_subnetwork_slo" {
  type = string
}

variable "gcp_subnetwork_sli" {
  type = string
}

