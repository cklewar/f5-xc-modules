variable "is_multi_nic" {
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

variable "slo_vpc_network_id" {
  type = string
}

variable "slo_subnet_name" {
  type = string
}

variable "sli_subnet_name" {
  type = string
}

variable "sli_vpc_network_id" {
  type = string
}