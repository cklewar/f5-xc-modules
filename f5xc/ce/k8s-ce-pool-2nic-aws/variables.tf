variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "session_token" {
  type    = string
  default = ""
}

variable "region" {
  type = string
}

variable "deployment" {
  type = string
  default = "ce-single-aws"
}

variable "environment" {
  type = string
  default = "staging"
}

variable "machine_image" {
  type = string
}

variable "machine_names" {
  type = list(string)
  default = []
}

variable "machine_count" {
  type = string
  default = "0"
}

variable "machine_type" {
  type = string
  default = "t3.medium"
}

variable "machine_config" {
}

variable "machine_public_key" {
  type = string
}

variable "subnet_private_id" {
  type = string
}

variable "subnet_inside_id" {
  type = string
}

variable "security_group_private_id" {
  type = string
}

variable "dns_zone_id" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "maurice_endpoint" {
  type = string
}

variable "dhcp_id" {
  type = string
}

variable "machine_disk_size" {
  type = string
  default = "40"
}

variable "iam_owner" {
  type    = string
  default = "default"
}

variable "key_name" {
  type = string
}