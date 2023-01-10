variable "instance_name" {
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

variable "ssh_public_key" {
  type = string
}

variable "user_data" {
  type = string
}

variable "cluster_size" {
  type    = number
  default = 1
}

variable "registration_wait_time" {
  type    = number
  default = 60
}

variable "registration_retry" {
  type    = number
  default = 20
}