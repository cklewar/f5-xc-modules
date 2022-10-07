variable "gcp_compute_firewall_name" {
  type    = string
  default = "allow-ssh"
}

variable "gcp_compute_firewall_compute_network" {
  type = string
}