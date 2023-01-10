variable "cluster_type" {
  type    = string
  default = "ce"
}

variable "maurice_endpoint" {
  type    = string
  default = "https://register.ves.volterra.io"
}

variable "maurice_mtls_endpoint" {
  type    = string
  default = "https://register-tls.ves.volterra.io"
}

variable "gateway_type" {
  type    = string
  default = "ingress_gateway"
}

variable "cluster_latitude" {
  type = string
}

variable "cluster_longitude" {
  type = string
}

variable "slo_nic" {
  type    = string
  default = "eth0"
}

variable "public_name" {
  type    = string
  default = "vip"
}

variable "certified_hardware_endpoint" {
  type    = string
  default = "https://vesio.blob.core.windows.net/releases/certified-hardware/gcp.yml"
}

variable "instance_name" {
  type = string
}

variable "volterra_token" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "cluster_labels" {
  type = map(string)
}

locals {
  gateway_type = replace(var.gateway_type, "_", "-")
  vpm_vars     = {
    service_ip                  = var.public_name
    cluster_type                = var.cluster_type
    cluster_name                = var.instance_name
    private_nic                 = var.slo_nic
    cluster_token               = var.volterra_token
    cluster_latitude            = var.cluster_latitude
    cluster_longitude           = var.cluster_longitude
    maurice_endpoint            = var.maurice_endpoint
    maurice_mtls_endpoint       = var.maurice_mtls_endpoint
    certified_hardware_endpoint = var.certified_hardware_endpoint
    cluster_labels              = var.cluster_labels
  }
  hosts_localhost_vars = {
    public_address = "127.0.1.1"
    public_name    = var.public_name
  }
  cloud_init_master = {
    vp_manager_context = base64encode(local.vpm_config.config)
    hosts_context      = base64encode(local.hosts_localhost.config)
    user_pubkey        = var.machine_public_key
  }
  # /etc/hosts
  hosts_localhost = {
    config = templatefile("${path.module}/templates/hosts", local.hosts_localhost_vars)
  }

  # vpm config
  vpm_config = {
    config = templatefile("${path.module}/templates/vpm-${local.gateway_type}.yml", local.vpm_vars)
  }

  # ssh public key and cloud_init files
  cloud_init_master_config = {
    config = templatefile("${path.module}/templates/cloud-init.yml", local.cloud_init_master)
  }
}

