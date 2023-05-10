variable "f5xc_namespace" {
  type = string
}

variable "f5xc_enhanced_fw_policy_name" {
  type = string
}

variable "f5xc_enhanced_fw_policy_rules" {
  type = list(object({
    allow      = optional(bool)
    all_source = optional(bool)
    metadata   = object({
      name = string
    })
    source_aws_vpc_ids = optional(object({
      vpc_id = list(string)
    }))
    destination_aws_vpc_ids = optional(object({
      vpc_id = list(string)
    }))
    source_prefix_list = optional(object({
      prefixes = list(string)
    }))
    destination_prefix_list = optional(object({
      prefixes = list(string)
    }))
    applications = optional(object({
      applications = list(string)
    }))
    insert_service = optional(object({
      nfv_service = object({
        name = string
      })
    }))
  }))
}