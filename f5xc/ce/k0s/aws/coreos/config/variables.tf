variable "coreos_ami_owner_id" {
  type    = string
  default = "125523088429"
}

variable "butane_variant" {
  type = string
}

variable "butane_version" {
  type = string
}

variable "k0s_version" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "f5xc_site_token" {
  type = string
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_custom_vip_cidr" {
  type = string
}

variable "ce_config_template_file" {
  type    = string
  default = "./templates/ce.yml"
}