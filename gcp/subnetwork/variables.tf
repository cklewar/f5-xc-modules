variable "gcp_region" {
  type = string
}

variable "gcp_compute_network_delete_default_routes_on_create" {
  type    = bool
  default = false
}

variable "gcp_compute_subnetwork_ip_cidr_range" {
  type = string
}

variable "gcp_compute_subnetwork_name" {
  type = string
}

variable "gcp_compute_network_id" {
  type = string
}

variable "gcp_compute_subnetwork_secondary_ip_range_range_name" {
  type    = string
  default = ""
}

variable "gcp_compute_subnetwork_secondary_ip_range_ip_cidr_range" {
  type    = string
  default = ""
}