variable "csp_provider" {
  type = string
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.csp_provider)
    error_message = format("Valid values for csp_provider: aws, gcp, azure")
  }
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_master_nodes" {
  type = list(string)
}

variable "f5xc_worker_nodes" {
  type = list(string)
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_k8s_cluster_name" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["voltstack_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: voltstack_gateway")
  }
}

variable "f5xc_site_type_certified_hw" {
  type = object({
    aws   = map(string)
    gcp   = map(string)
    azure = map(string)
  })
  default = {
    aws = {
      voltstack_gateway = "aws-byol-voltstack-combo"
    }
    gcp = {
      voltstack_gateway = "gcp-byol-voltstack-combo"
    }
    azure = {
      voltstack_gateway = "azure-free-voltmesh"
      # voltstack_gateway = "azure-byol-voltstack-combo"
    }
  }
}