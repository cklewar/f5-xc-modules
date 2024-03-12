variable "f5xc_cluster_latitude" {
  type    = number
  default = 37
}

variable "f5xc_cluster_longitude" {
  type    = number
  default = -121
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
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

variable "f5xc_rhel9_container" {
  type = string
}

variable "ssh_public_key" {
  type    = string
  default = ""
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_operating_system_version" {
  type = string
}

variable "f5xc_certified_hardware_profile" {
  type = string
}

variable "f5xc_k8s_config_type" {
  type = string
}

variable "master_nodes_count" {
  type    = number
  default = 1
}

variable "worker_nodes_count" {
  type    = number
  default = 0
}

variable "master_node_cpus" {
  type    = number
  default = 8
}

variable "worker_node_cpus" {
  type    = number
  default = 4
}

variable "master_node_memory" {
  type = string
}

variable "worker_node_memory" {
  type = string
}

variable "slo_network" {
  type    = string
  default = ""
}

variable "admin_password" {
  type = string
}

variable "worker_node_ip_address_prefix" {
  type = string
}

variable "worker_node_ip_address_suffix" {
  type = string
}

variable "master_node_ip_address_prefix" {
  type = string
}

variable "master_node_ip_address_suffix" {
  type = string
}

variable "ip_gateway" {
  type = string
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "owner_tag" {
  type = string
}

variable "is_sensitive" {
  type    = bool
  default = false
}

variable "is_kubevirt" {
  type    = bool
  default = false
}

variable "site_registration_token" {
  type    = string
  default = ""
}

variable "master_node_manifest_template" {
  type = string
}

variable "worker_node_manifest_template" {
  type = string
}

variable "f5xc_k8s_infra_cluster_name" {
  type = string
}

variable "f5xc_k8s_infra_cluster_api_token" {
  type    = string
  default = ""
}

variable "f5xc_k8s_infra_cluster_api_url" {
  type    = string
  default = ""
}