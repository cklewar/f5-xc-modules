variable "f5xc_api_url" {
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

variable "instance_type" {
  type = string
}

variable "instance_image" {
  type = string
}

variable "instance_disk_size" {
  type = string
}

variable "instance_template_description" {
  type = string
}

variable "instance_template_create_timeout" {
  type = string
}

variable "instance_template_delete_timeout" {
  type = string
}

variable "instance_group_manager_description" {
  type = string
}

variable "instance_group_manager_distribution_policy_zones" {
  type = list(string)
}

variable "instance_group_manager_wait_for_instances" {
  type = bool
}

variable "instance_group_manager_base_instance_name" {
  type = string
}

variable "sli_subnetwork" {
  type = string
}

variable "slo_subnetwork" {
  type = string
}

variable "instance_tags" {
  type = list(string)
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type = string
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

variable "access_config_nat_ip" {
  type = string
}

variable "has_public_ip" {
  type = bool
}

variable "is_sensitive" {
  type = bool
}

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
  type    = map(string)
  default = {}
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}