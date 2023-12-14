variable "f5xc_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "contains_string" {
  type    = string
  default = "console"
}

variable "schema" {
  type    = string
  default = "https://"
}

variable "file_suffix" {
  type    = string
  default = ".api-creds.p12"
}