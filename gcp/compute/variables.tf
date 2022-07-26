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

variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "machine_disk_size" {
  type    = string
  default = "40"
}

variable "zone_names" {
  type = list(string)
}

variable "site_name" {
  type = string
}

variable "inside_subnet_name" {
  type = string
}

variable "google_compute_firewall_name" {
  type = string
  default = "allow-ssh"
}

variable "gcp_compute_instance_machine_type" {
  type = string
}

variable "compute_instance_machine_name" {
  type = string
}

variable "public_ssh_key" {
  type = string
}