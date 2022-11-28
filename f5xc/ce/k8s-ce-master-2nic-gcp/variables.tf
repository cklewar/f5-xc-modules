variable "api_p12_file" {
  type = string
}

variable "api_url" {
  type = string
}

variable "api_ca_cert" {
  type    = string
  default = ""
}

variable "api_cert" {
  type    = string
  default = ""
}

variable "api_key" {
  type    = string
  default = ""
}

variable "api_token" {
  type    = string
  default = ""
}

variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "credentials_file_path" {
  type = string
}

variable "name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "image" {
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

variable "machine_public_key" {
  type = string
}

variable "user_data" {
  type = string
}