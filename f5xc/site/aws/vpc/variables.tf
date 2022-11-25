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

variable "f5xc_aws_vpc_site_name" {
  type = string

  validation {
    condition     = length(var.f5xc_aws_vpc_site_name) <= 64
    error_message = format("Max length for f5xc_aws_vpc_site_name ist 64 characters")
  }
}

variable "f5xc_aws_region" {
  type = string

  validation {
    condition = contains([
      "us-east-2", "us-east-1", "us-west-1", "us-west-2", "af-south-1", "ap-east-1", "ap-southeast-3", "ap-south-1",
      "ap-northeast-3", "ap-northeast-2", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ca-central-1", "eu-central-1",
      "eu-west-1", "eu-west-2", "eu-south-1", "eu-west-3", "eu-north-1", "me-south-1", "sa-east-1"
    ], var.f5xc_aws_region)
    error_message = format("Valid values for f5xc_aws_region: us-east-2, us-east-1, us-west-1, us-west-2, af-south-1, ap-east-1, ap-southeast-3, ap-south-1, ap-northeast-3, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-northeast-1, ca-central-1, eu-central-1, eu-west-1, eu-west-2, eu-south-1, eu-west-3, eu-north-1,  me-south-1, sa-east-1")
  }
}

variable "f5xc_aws_cred" {
  type = string
}

variable "f5xc_aws_vpc_owner" {
  type = string
}

variable "f5xc_aws_vpc_primary_ipv4" {
  type    = string
  default = ""
}

variable "f5xc_aws_vpc_az_nodes" {
  type = map(map(string))
}

variable "f5xc_aws_default_ce_os_version" {
  type = bool
}

variable "f5xc_aws_ce_os_version" {
  type    = string
  default = ""
}

variable "f5xc_aws_default_ce_sw_version" {
  type = bool
}

variable "f5xc_aws_ce_sw_version" {
  type    = string
  default = ""
}

variable "f5xc_aws_ce_gw_type" {
  type    = string
  default = "multi_nic"

  validation {
    condition     = contains(["multi_nic", "single_nic"], var.f5xc_aws_ce_gw_type)
    error_message = format("Valid values for f5xc_aws_ce_gw_type: multi_nic, single_nic")
  }
}

variable "f5xc_aws_ce_certified_hw" {
  type    = map(string)
  default = {
    multi_nic  = "aws-byol-multi-nic-voltmesh"
    single_nic = "aws-byol-voltmesh"
    app_stack  = "aws-byol-voltstack-combo"
  }
}

variable "f5xc_aws_vpc_global_network_name" {
  type    = list(string)
  default = []
}

variable "f5xc_aws_vpc_no_global_network" {
  type    = bool
  default = true
}

/*variable "f5xc_aws_vpc_no_outside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_aws_vpc_no_inside_static_routes" {
  type    = bool
  default = true
}*/

variable "f5xc_aws_vpc_no_network_policy" {
  type    = bool
  default = true
}

variable "f5xc_aws_vpc_no_forward_proxy" {
  type    = bool
  default = true
}

variable "f5xc_aws_site_kind" {
  type    = string
  default = "aws_vpc_site"
}

variable "ssh_public_key" {
  type = string
}

variable "f5xc_aws_vpc_ce_instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "f5xc_aws_vpc_ce_instance_disk_size" {
  type    = number
  default = 80
}

variable "f5xc_aws_vpc_worker_nodes_per_az" {
  type    = number
  default = 0
}

variable "f5xc_aws_vpc_total_worker_nodes" {
  type    = number
  default = 0
}

variable "f5xc_aws_vpc_no_worker_nodes" {
  type = bool
}

variable "f5xc_aws_vpc_use_http_https_port" {
  type = bool
}

variable "f5xc_aws_vpc_use_http_https_port_sli" {
  type = bool
}

variable "f5xc_aws_vpc_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_aws_vpc_existing_id" {
  type    = string
  default = ""
}

variable "f5xc_nic_type_single_nic" {
  type    = string
  default = "single_nic"
}

variable "f5xc_nic_type_multi_nic" {
  type    = string
  default = "multi_nic"
}

variable "f5xc_tf_params_action" {
  type    = string
  default = "apply"

  validation {
    condition     = contains(["apply", "plan"], var.f5xc_tf_params_action)
    error_message = format("Valid values for f5xc_tf_params_action: apply, plan")
  }
}

variable "f5xc_tf_wait_for_action" {
  type    = bool
  default = true
}

variable "f5xc_cloud_site_labels_ignore_on_delete" {
  type    = bool
  default = true
}

variable "f5xc_labels" {
  type    = map(string)
  default = {}
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "f5xc_aws_vpc_direct_connect_disabled" {
  type    = bool
  default = true
}

variable "f5xc_aws_vpc_direct_connect_manual_gw" {
  type    = bool
  default = false
}

variable "f5xc_aws_vpc_direct_connect_hosted_vifs" {
  type    = list(string)
  default = []
}

variable "f5xc_aws_vpc_direct_connect_standard_vifs" {
  type    = bool
  default = false
}

variable "f5xc_aws_vpc_direct_connect_custom_asn" {
  type    = number
  default = 0
}

variable "f5xc_aws_vpc_cloud_aggregated_prefix" {
  type    = list(string)
  default = []
}

variable "f5xc_aws_vpc_dc_connect_aggregated_prefix" {
  type    = list(string)
  default = []
}

variable "f5xc_aws_vpc_inside_static_routes" {
  type    = list(string)
  default = []
}

variable "f5xc_aws_vpc_outside_static_routes" {
  type    = list(string)
  default = []
}

