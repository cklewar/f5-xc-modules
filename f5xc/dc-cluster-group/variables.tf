variable "f5xc_namespace" {
  type = string
}

variable "f5xc_dc_cluster_group_name" {
  type = string
}

variable "f5xc_dc_cluster_group_description" {
  type    = string
  default = ""
}

variable "f5xc_dc_cluster_group_labels" {
  type    = map(string)
  default = {}
}

