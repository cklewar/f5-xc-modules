variable "is_multi_nic" {
  type = bool
}

variable "auto_create_subnetworks" {
  type = bool
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}

variable "gcp_region" {
  type = string
}

variable "subnet_slo_ip_cidr_range" {
  type = string
}

variable "subnet_sli_ip_cidr_range" {
  type = string
}

variable "slo_subnet_name" {
  type = string
}

variable "sli_subnet_name" {
  type = string
}