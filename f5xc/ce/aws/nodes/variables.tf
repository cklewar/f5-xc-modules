variable "owner_tag" {
  type = string
}

variable "is_multi_nic" {
  type = bool
}

variable "common_tags" {
  type = map(string)
}

variable "aws_instance_image" {
  type = string
}

variable "aws_instance_type" {
  type = string
}

variable "aws_instance_create_timeout" {
  type    = string
  default = "60m"
}

variable "aws_instance_update_timeout" {
  type    = string
  default = "30m"
}

variable "aws_instance_delete_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_public_key_name" {
  type = string
}

variable "aws_instance_disk_size" {
  type    = string
  default = "40"
}

variable "aws_instance_monitoring" {
  type    = bool
  default = false
}

variable "aws_lb_target_group_arn" {
  type = string
}

variable "aws_interface_slo_id" {
  type = string
}

variable "aws_interface_sli_id" {
  type = string
}

variable "aws_iam_instance_profile_id" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_registration_wait_time" {
  type = number
}

variable "f5xc_registration_retry" {
  type = number
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_size" {
  type = number
  validation {
    condition     = var.f5xc_cluster_size == 1 || var.f5xc_cluster_size == 3
    error_message = format("Valid values for f5xc_cluster_size: 1 or 3")
  }
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_instance_config" {
  type = string
}

variable "f5xc_ce_to_re_tunnel_types" {
  type = object({
    ssl   = string
    ipsec = string
  })
  default = {
    ssl   = "SITE_TO_SITE_TUNNEL_SSL"
    ipsec = "SITE_TO_SITE_TUNNEL_IPSEC_OR_SSL"
  }
}

variable "f5xc_ce_to_re_tunnel_type" {
  type = string
}