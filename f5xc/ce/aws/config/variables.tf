variable "certified_hardware_endpoint" {
  type    = string
  default = "https://vesio.blob.core.windows.net/releases/certified-hardware/aws.yml"
}

variable "reboot_strategy_node" {
  type    = string
  default = "off"
}

variable "reboot_strategy_pool" {
  type    = string
  default = "off"
}

variable "public_address" {
  type = string
}

variable "public_name" {
  type = string
}

variable "container_images" {
  type    = map(string)
  default = {
    "Hyperkube" = ""
    "CoreDNS"   = ""
    "Etcd"      = ""
  }
}

variable "cluster_latitude" {
  type = number
}

variable "cluster_longitude" {
  type = number
}

variable "cluster_workload" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "private_default_gw" {
  type    = string
  default = ""
}

variable "private_vn_prefix" {
  type    = string
  default = ""
}

variable "site_token" {
  type = string
}

variable "cluster_labels" {
  type = map(string)
}

variable "customer_route" {
  type    = string
  default = ""
}

variable "vp_manager_version" {
  type    = string
  default = "latest"
}

variable "cluster_type" {
  type    = string
  default = "ce"
}

variable "vp_manager_node_skip_stages" {
  type        = list(string)
  default     = ["register", "ver"]
  description = "List of VP manager stages to skip on node"
}

variable "vp_manager_pool_skip_stages" {
  type        = list(string)
  default     = ["register"]
  description = "List of VP manager stages to skip on pool"
}

variable "vp_manager_mask_fetch_latest" {
  type    = string
  default = "true"
}

variable "maurice_endpoint" {
  type    = string
  default = "https://register.ves.volterra.io"
}

variable "maurice_mtls_endpoint" {
  type    = string
  default = "https://register-tls.ves.volterra.io"
}

variable "cluster_uid" {
  type    = string
  default = ""
}


variable "ssh_public_key" {
  type = string
}

variable "ntp_servers" {
  type    = string
  default = "pool.ntp.org"
}

variable "server_roles" {
  type = string
}

variable "private_nic" {
  type    = string
  default = ""
}

variable "public_nic" {
  type    = string
  default = ""
}

variable "owner_tag" {
  type = string
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "templates_dir" {
  type    = string
  default = "templates"
}