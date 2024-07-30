variable "f5os_api_username" {
  type = string
}

variable "f5os_api_password" {
  type = string
}

variable "f5os_tenant" {
  type = string
}

variable "f5os_tenant_get_uri" {
  type    = string
  default = "restconf/data/f5-tenants:tenants/tenant=%s"
}

variable "status_check_type" {
  type    = string
}

variable "check_type_basic" {
  type    = string
  default = "basic"
}

variable "f5os_max_timeout" {
  type    = number
  default = 3600
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}