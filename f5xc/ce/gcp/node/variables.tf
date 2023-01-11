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

variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_image" {
  type = string
}

variable "machine_disk_size" {
  type = string
}

variable "sli_subnetwork" {
  type = string
}

variable "slo_subnetwork" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "f5xc_ce_user_data" {
  type = string
}

variable "f5xc_cluster_size" {
  type = number
}

variable "f5xc_registration_wait_time" {
  type = number
}

variable "f5xc_registration_retry" {
  type = number
}