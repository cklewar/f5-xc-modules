variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  description = "F5 XC tenant"
  type        = string
  default     = ""
}

variable "status_check_type" {
  type    = string
  default = "token"
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_k8s_cluster_name" {
  type = string
}

variable "f5xc_rest_uri_sites" {
  type    = string
  default = "web/namespaces/system/sites"
}

variable "f5xc_k8s_config_type" {
  type = string
  validation {
    condition     = contains(["global", "local"], var.f5xc_k8s_config_type)
    error_message = format("Valid values for f5xc_k8s_config_type: global, local")
  }
}

variable "f5xc_k8s_config_types" {
  type = map(string)
  default = {
    global = "global-kubeconfigs"
    local  = "local-kubeconfigs"
  }
}

variable "f5xc_api_p12_file" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_cert_password" {
  type    = string
  default = ""
}

variable "output_dir_path" {
  type    = string
  default = ""
}