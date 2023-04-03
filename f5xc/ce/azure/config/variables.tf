variable "f5xc_certified_hardware_endpoint" {
  type    = string
  default = "https://vesio.blob.core.windows.net/releases/certified-hardware/aws.yml"
}

variable "maurice_endpoint" {
  type    = string
  default = "https://register.ves.volterra.io"
}

variable "maurice_mtls_endpoint" {
  type    = string
  default = "https://register-tls.ves.volterra.io"
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "customer_route" {
  type    = string
  default = ""
}

variable "f5xc_site_token" {
  type = string
}

variable "f5xc_cluster_type" {
  type    = string
  default = "ce"
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_ce_hosts_public_name" {
  type = string
}

variable "f5xc_ce_hosts_public_address" {
  type    = string
  default = "127.0.1.1"
}

variable "f5xc_azure_region" {
  type = string
}

variable "azurerm_tenant_id" {
  type = string
}

variable "azurerm_subscription_id" {
  type = string
}

variable "azurerm_client_id" {
  type = string
}

variable "azurerm_client_secret" {
  type = string
}

variable "azurerm_cloud_name" {
  type    = string
  default = "AzurePublicCloud"
}

variable "ssh_public_key" {
  type = string
}

variable "ntp_servers" {
  type    = string
  default = "pool.ntp.org"
}

variable "owner_tag" {
  type = string
}

variable "templates_dir" {
  type    = string
  default = "templates"
}

variable "reboot_strategy_node" {
  type    = string
  default = "off"
}