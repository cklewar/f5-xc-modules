variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_site_2_site_connection_type" {
  type    = string
  default = "full_mesh"
}

variable "ssh_public_key_file" {
  type = string
}

variable "f5xc_site_mesh_group_name" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_secure_mesh_site_prefix" {
  type    = string
  default = ""
}

variable "f5xc_secure_mesh_site_suffix" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_selector_expression" {
  type    = list(string)
  default = []
}

variable "f5xc_create_site_mesh_group" {
  type    = bool
  default = false
}

variable "f5xc_create_virtual_site" {
  type    = bool
  default = true
}

variable "f5xc_secure_mesh_site" {
  type = object({
    aws = optional(list(object({
      owner                           = string
      region                          = string
      is_sensitive                    = optional(bool, false)
      has_public_ip                   = bool
      vpc_cidr_block                  = string
      f5xc_token_name                 = string
      f5xc_cluster_name               = string
      f5xc_cluster_labels             = map(string)
      f5xc_ce_gateway_type            = string
      f5xc_cluster_latitude           = string
      f5xc_cluster_longitude          = string
      security_group_rules_slo_egress = optional(list(object({
        from_port   = number
        to_port     = number
        ip_protocol = string
        cidr_blocks = list(string)
      })), [])
      security_group_rules_slo_ingress = optional(list(object({
        from_port   = number
        to_port     = number
        ip_protocol = string
        cidr_blocks = list(string)
      })), [])
      f5xc_nodes = map(object({
        f5xc_aws_vpc_az_name    = string
        f5xc_aws_vpc_slo_subnet = string
        f5xc_aws_vpc_sli_subnet = optional(string)
      }))
    })))
    gcp = optional(list(object({
      region                         = string
      is_sensitive                   = optional(bool, false)
      machine_type                   = string
      project_name                   = string
      machine_image                  = string
      has_public_ip                  = bool
      machine_disk_size              = string
      existing_network_inside        = optional(object({}))
      existing_network_outside       = optional(object({}))
      subnet_slo_ip_cidr_range       = string
      existing_fabric_subnet_outside = optional(string)
      f5xc_token_name                = string
      f5xc_cluster_name              = string
      f5xc_cluster_labels            = map(string)
      f5xc_ce_gateway_type           = string
      f5xc_cluster_latitude          = string
      f5xc_cluster_longitude         = string
      f5xc_nodes                     = map(object({
        az_name    = string
        slo_subnet = string
        sli_subnet = optional(string)
      }))
    })))
    azure = optional(list(object({
      owner                    = string
      region                   = string
      tenant_id                = string
      client_id                = string
      is_sensitive             = optional(bool, false)
      has_public_ip            = bool
      client_secret            = string
      subscription_id          = string
      vnet_address_space       = list(string)
      f5xc_cluster_name        = string
      f5xc_cluster_labels      = map(string)
      f5xc_ce_gateway_type     = string
      f5xc_cluster_latitude    = string
      f5xc_cluster_longitude   = string
      security_group_rules_slo = optional(list(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_port_range            = string
        destination_port_range       = string
        source_address_prefix        = optional(string)
        source_address_prefixes      = optional(list(string))
        destination_address_prefix   = optional(string)
        destination_address_prefixes = optional(list(string))
      })), [])
      instance_admin_username = string
      f5xc_nodes              = map(object({
        f5xc_azure_az              = string
        f5xc_azure_vnet_slo_subnet = string
        f5xc_azure_vnet_sli_subnet = optional(string)
      }))
    })))
    vmware = optional(list(object({
      is_sensitive                   = optional(bool, false)
      f5xc_cluster_name              = string
      f5xc_cluster_labels            = map(string)
      f5xc_ce_gateway_type           = string
      f5xc_cluster_latitude          = string
      f5xc_cluster_longitude         = string
      f5xc_vsphere_instance_template = optional(string)
      vsphere_cluster                = string
      vsphere_datacenter             = string
      vsphere_instance_dns_servers   = object({
        primary   = string
        secondary = optional(string)
      })
      vsphere_instance_admin_password                    = string
      vsphere_instance_inside_network_name               = string
      vsphere_instance_outside_network_name              = string
      vsphere_instance_outside_interface_default_route   = string
      vsphere_instance_outside_interface_default_gateway = string
      f5xc_nodes                                         = map(object({
        host                       = string
        dhcp                       = optional(bool, false)
        datastore                  = string
        adapter_type               = optional(string, "vmxnet3")
        outside_network_ip_address = string
      }))
    })))
  })
}

variable "f5xc_site_type_certified_hw" {
  type    = map(string)
  default = {
    aws    = "aws-byol-voltmesh"
    gcp    = "gcp-byol-voltmesh"
    kvm    = "kvm-voltmesh"
    azure  = "azure-byol-voltmesh"
    vmware = "vmware-voltmesh"
  }
}