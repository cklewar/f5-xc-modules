variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_key" {
  type    = string
  default = ""
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "public_ssh_key" {
  type = string
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

variable "f5xc_aws_tgw_name" {
  type = string
}

variable "f5xc_aws_tgw_instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "f5xc_aws_tgw_ce_instance_disk_size" {
  type    = number
  default = 80
}

variable "f5xc_aws_tgw_primary_ipv4" {
  type = string
  default = ""
}

variable "f5xc_aws_cred" {
  type = string
}

variable "f5xc_aws_tgw_az_nodes" {
  type    = map(map(string))
  default = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/24", f5xc_aws_tgw_outside_subnet = "192.168.169.0/24"
      f5xc_aws_tgw_az_name         = "us-east-2a"
    }
  }
}

variable "f5xc_aws_tgw_vpc_attach_label_deploy" {
  type = string
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

variable "f5xc_aws_certified_hw" {
  type    = string
  default = "aws-byol-multi-nic-voltmesh"
}

variable "f5xc_aws_vpc_attachment_ids" {
  type    = list(string)
  default = []
}

variable "f5xc_site_kind" {
  type    = string
  default = "aws_tgw_site"
}

variable "f5xc_aws_tgw_existing_id" {
  type = string
  default = ""
}

variable "f5xc_aws_tgw_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_aws_tgw_reserved_inside_subnet" {
  type    = bool
  default = true
}

variable "f5xc_aws_tgw_vpc_allocate_ipv6" {
  type    = bool
  default = false
}

variable "f5xc_aws_tgw_vpc_autogenerate" {
  type    = bool
  default = true
}

variable "f5xc_aws_tgw_vpc_system_generated" {
  type    = bool
  default = true
}

variable "f5xc_aws_tgw_worker_nodes_per_az" {
  type    = number
  default = 0
}

variable "f5xc_aws_tgw_total_worker_nodes" {
  type    = number
  default = 0
}

variable "f5xc_aws_tgw_no_worker_nodes" {
  type = bool
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

variable "aws_owner_tag" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}
