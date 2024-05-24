variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_certified_hardware" {
  type    = string
  default = "gcp-byol-voltmesh" # "gcp-byol-voltstack-combo"
}

variable "f5xc_master_nodes" {
  type = list(string)
}

variable "f5xc_worker_nodes" {
  type = list(string)
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_k8s_cluster_name" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}