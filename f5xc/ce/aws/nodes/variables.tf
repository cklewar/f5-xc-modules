variable "common_tags" {
  type = map(string)
}

variable "is_sensitive" {
  type = bool
}

variable "instance_image" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "owner_tag" {
  type = string
}

variable "instance_create_timeout" {
  type    = string
  default = "60m"
}

variable "node_name" {
  type = string
}

variable "instance_delete_timeout" {
  type    = string
  default = "60m"
}

variable "instance_config" {
  type = string
}

variable "subnet_slo_id" {
  type = string
}

variable "subnet_sli_id" {
  type = string
}

variable "security_group_slo_id" {
  type = string
}

variable "public_ssh_key_name" {
  type = string
}

variable "security_group_sli_id" {
  type = string
}

variable "machine_disk_size" {
  type    = string
  default = "40"
}

variable "cluster_name" {
  type = string
}

variable "instance_monitoring" {
  type    = bool
  default = false
}

variable "cluster_size" {
  type = number
  validation {
    condition     = var.cluster_size == 1 || var.cluster_size == 3
    error_message = format("Valid values for f5xc_cluster_size: 1 or 3")
  }
}

variable "lb_target_group_arn" {
  type = string
}

variable "interface_slo_id" {
  type = string
}

variable "interface_sli_id" {
  type = string
}

variable "iam_instance_profile_id" {
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

variable "f5xc_namespace" {
  type = string
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