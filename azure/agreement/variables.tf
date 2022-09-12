variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "f5xc_azure_ce_gw_type" {
  type = string

  validation {
    condition     = contains(["multi_nic", "single_nic", "app_stack"], var.f5xc_azure_ce_gw_type)
    error_message = format("Valid values for f5xc_azure_ce_gw_type: multi_nic, single_nic, app_stack")
  }
}

variable "f5xc_azure_marketplace_agreement_offers" {
  type    = map(string)
  default = {
    multi_nic  = "entcloud_voltmesh_voltstack_node"
    single_nic = "volterra-node"
    app_stack  = "entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_azure_marketplace_agreement_plans" {
  type    = map(string)
  default = {
    multi_nic  = "freeplan_entcloud_voltmesh_voltstack_node_multinic"
    single_nic = "volterra-node"
    app_stack  = "freeplan_entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_azure_marketplace_agreement_publisher" {
  type    = string
  default = "volterraedgeservices"
}

variable "azure_marketplace_agreement_plan_generic" {
  type    = string
  default = ""
}

variable "azure_marketplace_agreement_offer_generic" {
  type    = string
  default = ""
}