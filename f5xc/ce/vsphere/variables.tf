variable "f5xc_tenant" {}
variable "f5xc_api_url" {}
variable "f5xc_api_ca_cert" {}
variable "f5xc_namespace" {}
variable "f5xc_api_token" {}

variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_datacenter" {}
variable "vsphere_cluster" {}

variable "nodes" {
  type = list(object({
    name      = string
    datastore = string
    ipaddress = string
    host      = string
  }))
}

variable "outside_network" {}
variable "inside_network" {
  type = string
  default = ""
}
variable "publicdefaultgateway" {
  type = string
  default = ""
}
variable "publicdefaultroute" {
  type = string
  default = ""
}
variable "dnsservers" {}
variable "cpus" {}
variable "memory" {}
variable "f5xc_ova_image" {
  type = string
  default = ""
}
variable "f5xc_vm_template" {
  type = string
  default = ""
}
variable "f5xc_reg_url" {
  type    = string
  default = "ves.volterra.io"
}

variable "certifiedhardware" {}
variable "cluster_name" {}
variable "guest_type" {}
variable "sitelatitude" {}
variable "sitelongitude" {}
variable "admin_password" {
  type = string
  default = ""
  description = "admin shell password, needs at least one uppercase letter"
}
