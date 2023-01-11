variable "gcp_region" {
  type = string
}

variable "fabric_subnet_public" {
  type = string
}

variable "fabric_subnet_inside" {
  type = string
}

variable "network_name" {
  type = string
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}