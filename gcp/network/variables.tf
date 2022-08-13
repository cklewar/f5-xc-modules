variable "gcp_project_name" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "gcp_credentials_file_path" {
  type    = string
  default = ""
}

variable "gcp_compute_instance_machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "gcp_compute_instance_machine_disk_size" {
  type    = string
  default = "40"
}

variable "gcp_zone_names" {
  type = list(string)
}

variable "gcp_site_name" {
  type = string
}

variable "gcp_compute_instance_inside_subnet_name" {
  type = string
}

variable "gcp_compute_firewall_name" {
  type    = string
  default = "allow-ssh"
}

variable "gcp_compute_instance_machine_name" {
  type = string
}

variable "gcp_google_compute_instance_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "gcp_compute_instance_metadata_startup_script" {
  type    = string
  default = "<<-EOF #!/bin/bash sleep 30 sudo apt-get update sudo apt-get -y install net-tools tcpdump traceroute iputils-ping EOF"
}

variable "gcp_google_credentials" {
  type    = string
  default = ""
}

variable "public_ssh_key" {
  type = string
}