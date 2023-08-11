variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_update_uri" {
  type = string
}

variable "f5xc_api_get_uri" {
  type = string
}

variable "merge_key" {
  type = string
}

variable "del_key" {
  type = string
}

variable "merge_data" {
  type = string
}

variable "output_file_name" {
  type    = string
  default = "merged_data.json"
}