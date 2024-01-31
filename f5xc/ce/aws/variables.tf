variable "is_sensitive" {
  description = "mark module output as sensitive"
  type        = bool

}

variable "has_public_ip" {
  description = "whether the CE gets a public IP assigned to SLO"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "AWS EC2 instance flavour"
  type        = string
  default     = "t3.xlarge"
}

variable "owner_tag" {
  description = "set a tag called owner"
  type        = string
}

variable "create_new_aws_vpc" {
  description = "create new aws vpc"
  type        = bool
  default     = true
}

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
}

variable "cluster_workload" {
  type    = string
  default = ""
}

variable "ssh_public_key" {
  description = "EC2 instance assigned public ssh key"
  type        = string

}

variable "aws_existing_vpc_id" {
  description = "inject existing aws vpc id"
  type        = string
  default     = ""
}

variable "aws_security_group_rules_slo_egress_default" {
  description = "default aws security groups assigned to slo egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = -1
      to_port     = -1
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rules_slo_ingress_default" {
  description = "default aws security groups assigned to slo ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = -1
      to_port     = -1
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rules_sli_egress_default" {
  description = "aws security groups assigned to sli egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = -1
      to_port     = -1
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rules_sli_ingress_default" {
  description = "aws security groups assigned to sli ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = -1
      to_port     = -1
      ip_protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rules_slo_egress" {
  description = "provide custom aws security groups assigned to slo egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_ingress" {
  description = "provide custom aws security groups assigned to slo ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_egress" {
  description = "provide custom aws security groups assigned to sli egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "aws_security_group_rules_sli_ingress" {
  description = "provide custom aws security groups assigned to sli ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "f5xc_cluster_labels" {
  description = "F5 XC CE Cluster labels"
  type        = map(string)
}

variable "f5xc_cluster_latitude" {
  description = "geo latitude"
  type        = number
  default     = -73.935242
}

variable "f5xc_cluster_longitude" {
  description = "geo longitude"
  type        = number
  default     = 40.730610
}

variable "f5xc_api_url" {
  description = "F5 XC tenant api URL"
  type        = string
}

variable "f5xc_api_ca_cert" {
  description = "F5 XC api ca cert"
  type        = string
  default     = ""
}

variable "f5xc_api_token" {
  description = "F5 XC api token"
  type        = string
}

variable "f5xc_tenant" {
  description = "F5 XC tenant"
  type        = string
}

variable "f5xc_token_name" {
  description = "F5 XC api token name"
  type        = string
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_ce_gateway_type_voltstack" {
  type    = string
  default = "voltstack"
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
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway", "voltstack"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway, voltstack")
  }
}

variable "f5xc_ce_to_re_tunnel_type" {
  description = "CE to RE tunnel type"
  type        = string
  validation {
    condition     = contains(["ssl", "ipsec"], var.f5xc_ce_to_re_tunnel_type)
    error_message = format("Valid values for tunnel_type: ssl, ipsec")
  }
  default = "ipsec"
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_aws_vpc_az_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_aws_vpc_az_nodes) == 1 || length(var.f5xc_aws_vpc_az_nodes) == 3 || length(var.f5xc_aws_vpc_az_nodes) == 0
    error_message = "f5xc_aws_vpc_az_nodes must be 0,1 or 3"
  }
}

variable "f5xc_aws_region" {
  description = "AWS region"
  type        = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  description = "whether CE should be secured by applying security rules on SLO and SLI"
  type        = bool
  default     = false
}

variable "f5xc_ce_slo_enable_secure_sg" {
  description = "whether CE should be secured by applying security rules on SLO"
  type        = bool
  default     = false
}

variable "f5xc_site_type_is_secure_mesh_site" {
  type    = bool
  default = true
}

variable "f5xc_ce_machine_image" {
  type = object({
    ingress_gateway = object({
      af-south-1     = string
      ap-east-1      = string
      ap-northeast-1 = string
      ap-northeast-2 = string
      ap-northeast-3 = string
      ap-south-1     = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      ap-southeast-3 = string
      ca-central-1   = string
      eu-central-1   = string
      eu-north-1     = string
      eu-south-1     = string
      eu-west-1      = string
      eu-west-2      = string
      eu-west-3      = string
      me-south-1     = string
      sa-east-1      = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
    ingress_egress_gateway = object({
      af-south-1     = string
      ap-east-1      = string
      ap-northeast-1 = string
      ap-northeast-2 = string
      ap-northeast-3 = string
      ap-south-1     = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      ap-southeast-3 = string
      ca-central-1   = string
      eu-central-1   = string
      eu-north-1     = string
      eu-south-1     = string
      eu-west-1      = string
      eu-west-2      = string
      eu-west-3      = string
      me-south-1     = string
      sa-east-1      = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
    voltstack_gateway = object({
      af-south-1     = string
      ap-east-1      = string
      ap-northeast-1 = string
      ap-northeast-2 = string
      ap-northeast-3 = string
      ap-south-1     = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      ap-southeast-3 = string
      ca-central-1   = string
      eu-central-1   = string
      eu-north-1     = string
      eu-south-1     = string
      eu-west-1      = string
      eu-west-2      = string
      eu-west-3      = string
      me-south-1     = string
      sa-east-1      = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
  })
  default = {
    ingress_gateway = {
      af-south-1     = "ami-0abe8656ef9666ed9"
      ap-east-1      = "ami-00121c96d08755dc7"
      ap-northeast-1 = "ami-022eff0a8b29f0aa0"
      ap-northeast-2 = "ami-0baab800101568d4b"
      ap-northeast-3 = ""
      ap-south-1     = "ami-0b178530a3d2a135b"
      ap-southeast-1 = "ami-053df8b17f6cde147"
      ap-southeast-2 = "ami-0f8f02f4fd5aae93e"
      ap-southeast-3 = "ami-08fcddda640e5ccff"
      ca-central-1   = "ami-0173c5cb0bc2daf77"
      eu-central-1   = "ami-0156dae589b1bd776"
      eu-north-1     = "ami-078d5c45326b45a19"
      eu-south-1     = "ami-06f4833536f41ea5d"
      eu-west-1      = "ami-00cdd3b417a78da29"
      eu-west-2      = "ami-003b4907ae41e26ff"
      eu-west-3      = "ami-0e5b3114ca468df78"
      me-south-1     = "ami-041144ec799e3c2d3"
      sa-east-1      = "ami-0c3726fdda3296486"
      us-east-1      = "ami-0f0d5663398ae3232"
      us-east-2      = "ami-0d1c54456515b9a9b"
      us-west-1      = "ami-03dd4958a62da3fc4"
      us-west-2      = "ami-01aa136e8917ccef1"
    }
    ingress_egress_gateway = {
      af-south-1     = "ami-0abe8656ef9666ed9"
      ap-east-1      = "ami-00121c96d08755dc7"
      ap-northeast-1 = "ami-022eff0a8b29f0aa0"
      ap-northeast-2 = "ami-0baab800101568d4b"
      ap-northeast-3 = ""
      ap-south-1     = "ami-0b178530a3d2a135b"
      ap-southeast-1 = "ami-053df8b17f6cde147"
      ap-southeast-2 = "ami-0f8f02f4fd5aae93e"
      ap-southeast-3 = "ami-08fcddda640e5ccff"
      ca-central-1   = "ami-0173c5cb0bc2daf77"
      eu-central-1   = "ami-04720f54d40337fe2"
      eu-north-1     = "ami-078d5c45326b45a19"
      eu-south-1     = "ami-06f4833536f41ea5d"
      eu-west-1      = "ami-00cdd3b417a78da29"
      eu-west-2      = "ami-003b4907ae41e26ff"
      eu-west-3      = "ami-0e5b3114ca468df78"
      me-south-1     = "ami-041144ec799e3c2d3"
      sa-east-1      = "ami-0c3726fdda3296486"
      us-east-1      = "ami-0f0d5663398ae3232"
      us-east-2      = "ami-0d1c54456515b9a9b"
      us-west-1      = "ami-03dd4958a62da3fc4"
      us-west-2      = "ami-01aa136e8917ccef1"
    }
    voltstack_gateway = {
      af-south-1     = "ami-0abe8656ef9666ed9"
      ap-east-1      = "ami-00121c96d08755dc7"
      ap-northeast-1 = "ami-022eff0a8b29f0aa0"
      ap-northeast-2 = "ami-0baab800101568d4b"
      ap-northeast-3 = ""
      ap-south-1     = "ami-0b178530a3d2a135b"
      ap-southeast-1 = "ami-053df8b17f6cde147"
      ap-southeast-2 = "ami-0f8f02f4fd5aae93e"
      ap-southeast-3 = "ami-08fcddda640e5ccff"
      ca-central-1   = "ami-0173c5cb0bc2daf77"
      eu-central-1   = "ami-07860a3b1ab83ce62"
      eu-north-1     = "ami-078d5c45326b45a19"
      eu-south-1     = "ami-06f4833536f41ea5d"
      eu-west-1      = "ami-00cdd3b417a78da29"
      eu-west-2      = "ami-003b4907ae41e26ff"
      eu-west-3      = "ami-0e5b3114ca468df78"
      me-south-1     = "ami-041144ec799e3c2d3"
      sa-east-1      = "ami-0c3726fdda3296486"
      us-east-1      = "ami-0f0d5663398ae3232"
      us-east-2      = "ami-0d1c54456515b9a9b"
      us-west-1      = "ami-03dd4958a62da3fc4"
      us-west-2      = "ami-01aa136e8917ccef1"
    }
  }
}


variable "aws_vpc_cidr_block" {
  description = "AWS vpc CIDR block"
  type        = string
  default     = ""
}

variable "f5xc_ip_ranges_Americas_TCP" {
  type    = list(string)
  default = ["84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25", "23.158.32.0/25",]
}
variable "f5xc_ip_ranges_Americas_UDP" {
  type    = list(string)
  default = ["23.158.32.0/25", "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25",]
}
variable "f5xc_ip_ranges_Europe_TCP" {
  type    = list(string)
  default = ["84.54.60.0/25", "185.56.154.0/25", "159.60.162.0/24", "159.60.188.0/24", "5.182.212.0/25", "5.182.214.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25",]
}
variable "f5xc_ip_ranges_Europe_UDP" {
  type    = list(string)
  default = ["5.182.212.0/25", "185.56.154.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25", "5.182.214.0/25", "84.54.60.0/25", "159.60.162.0/24", "159.60.188.0/24",]
}
variable "f5xc_ip_ranges_Asia_TCP" {
  type    = list(string)
  default = ["103.135.56.0/25", "103.135.56.128/25", "103.135.58.128/25", "159.60.189.0/24", "159.60.166.0/24", "103.135.57.0/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.164.0/24",]
}
variable "f5xc_ip_ranges_Asia_UDP" {
  type    = list(string)
  default = ["103.135.57.0/25", "103.135.56.128/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.166.0/24", "159.60.164.0/24", "103.135.56.0/25", "103.135.58.128/25", "159.60.189.0/24",]
}

variable "f5xc_ce_egress_ip_ranges" {
  type        = list(string)
  description = "Egress IP ranges for F5 XC CE"
  default     = [
    "20.33.0.0/16",
    "74.125.0.0/16",
    "18.64.0.0/10",
    "52.223.128.0/18",
    "20.152.0.0/15",
    "13.107.238.0/24",
    "142.250.0.0/15",
    "20.34.0.0/15",
    "52.192.0.0/12",
    "52.208.0.0/13",
    "52.223.0.0/17",
    "18.32.0.0/11",
    "3.208.0.0/12",
    "13.107.237.0/24",
    "20.36.0.0/14",
    "52.222.0.0/16",
    "52.220.0.0/15",
    "3.0.0.0/9",
    "100.64.0.0/10",
    "54.88.0.0/16",
    "52.216.0.0/14",
    "108.177.0.0/17",
    "20.40.0.0/13",
    "54.64.0.0/11",
    "172.253.0.0/16",
    "20.64.0.0/10",
    "20.128.0.0/16",
    "172.217.0.0/16",
    "173.194.0.0/16",
    "20.150.0.0/15",
    "20.48.0.0/12",
    "72.19.3.0/24",
    "18.128.0.0/9",
    "23.20.0.0/14",
    "13.104.0.0/14",
    "13.96.0.0/13",
    "13.64.0.0/11",
    "13.249.0.0/16",
    "34.192.0.0/10",
    "3.224.0.0/12",
    "54.208.0.0/13",
    "54.216.0.0/14",
    "108.156.0.0/14",
    "54.144.0.0/12",
    "54.220.0.0/15",
    "54.192.0.0/12",
    "54.160.0.0/11",
    "52.88.0.0/13",
    "52.84.0.0/14",
    "52.119.128.0/17",
    "54.240.192.0/18",
    "52.94.208.0/21"
  ]
}