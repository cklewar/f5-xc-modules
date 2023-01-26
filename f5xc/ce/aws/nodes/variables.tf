variable "region" {
  default = "us-east-2"
}

variable "deployment" {
  default = "ce-single-aws"
}

variable "environment" {
  default = "staging"
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