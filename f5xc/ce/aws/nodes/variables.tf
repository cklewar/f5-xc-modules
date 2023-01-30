variable "region" {
  type = string
}

variable "machine_image" {
}

variable "machine_names" {
  default = []
}

variable "machine_count" {
  default = "0"
}

variable "machine_type" {
  default = "t3.medium"
}

variable "owner_tag" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_create_timeout" {
  type    = string
  default = "60m"
}

variable "instance_delete_timeout" {
  type    = string
  default = "60m"
}

variable "machine_config" {}

variable "machine_public_key" {}

variable "subnet_private_id" {}

variable "subnet_inside_id" {}

variable "security_group_private_id" {}

variable "machine_disk_size" {
  default = "40"
}

variable "target_group_arn" {
  default = ""
}

variable "disable_public_ip" {
  default = false
}

variable "enable_auto_registration" {
  default = false
}

variable "iam_owner" {
  default = "default"
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