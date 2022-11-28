variable "api_p12_file" {
  type = string
}

variable "api_url" {
  type = string
}

variable "api_ca_cert" {
  type    = string
  default = ""
}

variable "api_cert" {
  type    = string
  default = ""
}

variable "api_key" {
  type    = string
  default = ""
}

variable "api_token" {
  type    = string
  default = ""
}

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
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "machine_image" {
  type = string
}

variable "machine_names" {
  default = []
}

variable "machine_count" {
  type    = string
  default = "0"
}

variable "machine_type" {
  type    = string
  default = "t3.medium"
}

variable "machine_config" {
  type = string
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

variable "machine_disk_size" {
  type    = string
  default = "40"
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "disable_public_ip" {
  type    = bool
  default = false
}

variable "enable_auto_registration" {
  type    = bool
  default = false
}

variable "iam_owner" {
  type    = string
  default = "default"
}

variable "iam_instance_profile_name" {
  type = string
}

variable "key_name" {
  type = string
}