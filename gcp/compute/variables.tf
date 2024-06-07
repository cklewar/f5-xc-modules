variable "gcp_compute_instance_machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "gcp_compute_instance_machine_disk_size" {
  type    = string
  default = "40"
}

variable "gcp_zone_name" {
  type = string
}

variable "gcp_compute_instance_network_name" {
  type    = string
  default = ""
}

variable "gcp_compute_instance_network_interfaces" {
  type = list(object({
    network_name = optional(string)
    subnetwork_name = optional(string)
    network_ip = optional(string)
    access_config = optional(object({
      nat_ip = optional(string)
      network_tier = optional(string)
      public_ptr_domain_name = optional(string)
    }))
  }))
}

variable "gcp_compute_instance_subnetwork_name" {
  type    = string
  default = ""
}

variable "gcp_compute_instance_machine_name" {
  type = string
}

variable "gcp_compute_instance_userdata" {
  type    = string
  default = null
}

variable "gcp_google_compute_instance_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "gcp_compute_instance_metadata_startup_script" {
  type    = string
  default = null
}

variable "gcp_compute_instance_target_tags" {
  type = list(string)
  default = []
}

variable "gcp_compute_instance_labels" {
  type = map(string)
}

variable "ssh_public_key" {
  type = string
}

variable "template_input_dir_path" {
  type = string
}

variable "gcp_compute_instance_cloud_init_template_data" {
  type = map(string)
  default = {}
}

variable "gcp_compute_instance_cloud_init_template" {
  type    = string
  default = ""
}