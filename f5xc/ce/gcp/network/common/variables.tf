variable "is_multi_nic" {
  type = bool
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}

variable "gcp_auto_create_subnetworks" {
  type = bool
}

variable "gcp_existing_network_slo" {
  type = string
}

variable "gcp_existing_network_sli" {
  type = string
}

variable "gcp_existing_subnet_network_slo" {
  type = string
}

variable "gcp_existing_subnet_network_sli" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_subnet_ip_cidr_range_slo" {
  type = string
}

variable "gcp_subnet_ip_cidr_range_sli" {
  type = string
}

variable "gcp_subnet_name_slo" {
  type = string
}

variable "gcp_subnet_name_sli" {
  type = string
}

variable "create_network" {
  type = bool
}

variable "create_subnetwork" {
  type = bool
}