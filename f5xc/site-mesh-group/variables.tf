variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_site_mesh_group_name" {
  type = string
}

variable "f5xc_site_mesh_group_description" {
  type    = string
  default = ""
}

variable "f5xc_site_2_site_connection_type" {
  type = string

  validation {
    condition = contains(["hub_mesh", "spoke_mesh", "full_mesh"], var.f5xc_site_2_site_connection_type)
    error_message = format("Valid values for f5xc_site_2_site_connection_type: hub_mesh, spoke_mesh, full_mesh")
  }
}

variable "f5xc_site_2_site_connection_type_hub_mesh" {
  type    = string
  default = "hub_mesh"
}

variable "f5xc_site_2_site_connection_type_full_mesh" {
  type    = string
  default = "full_mesh"
}

variable "f5xc_site_2_site_connection_type_spoke_mesh" {
  type    = string
  default = "spoke_mesh"
}

variable "f5xc_site_site_hub_name" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_site_mesh_group_full_mesh_control_and_data_plane_mesh" {
  type    = bool
  default = false
}

variable "f5xc_site_mesh_group_full_mesh_data_plane_mesh" {
  type    = bool
  default = false
}

variable "f5xc_site_mesh_group_hub_mesh_control_and_data_plane_mesh" {
  type    = bool
  default = false
}

variable "f5xc_site_mesh_group_hub_mesh_data_plane_mesh" {
  type    = bool
  default = false
}

variable "f5xc_site_mesh_group_hub_mesh" {
  type    = bool
  default = false
}

variable "f5xc_labels" {
  type = map(string)
  default = {}
}

variable "f5xc_create_virtual_site" {
  type    = bool
  default = false
}

variable "f5xc_virtual_site_type" {
  type    = string
  default = "CUSTOMER_EDGE"
}

variable "f5xc_virtual_site_selector_expression" {
  type = list(string)
}

variable "f5xc_virtual_site_description" {
  type    = string
  default = ""
}

variable "f5xc_data_plane_mesh" {
  type    = bool
  default = true
}