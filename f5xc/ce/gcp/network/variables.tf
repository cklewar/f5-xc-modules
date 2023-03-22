variable "is_multi_nic" {
  type = bool
}

variable "gcp_region" {
  type = string
}

variable "subnet_slo" {
  type = string
}

variable "subnet_sli" {
  type = string
}

variable "project_name" {
  type = string
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}