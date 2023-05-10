variable "f5xc_namespace" {
  type = string
}

variable "f5xc_enhanced_fw_policy_name" {
  type = string
}

variable "rules" {
  type = list(object({
    allow      = bool
    all_source = bool
    metadata   = object({
      name = string
    })
    source_aws_vpc_ids = object({
      vpc_id = list(string)
    })
    source_prefix_list = object({
      prefixes = list(string)
    })
    destination_prefix_list = object({
      prefixes = list(string)
    })
    applications = object({
      applications = list(string)
    })
    insert_service = object({
      nfv_service = object({
        name = string
      })
    })
  }))
}