variable "is_sensitive" {
  type = bool
}

variable "has_public_ip" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "owner_tag" {
  type = string
}

variable "create_new_aws_vpc" {
  type    = bool
  default = true
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
  type = string
}

variable "aws_existing_vpc_id" {
  type    = string
  default = ""
}

variable "aws_security_group_rules_slo_egress_default" {
  type = list(object({
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
  type = list(object({
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
  type = list(object({
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
  type = list(object({
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
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "aws_security_group_rules_sli_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_cluster_latitude" {
  type    = number
  default = -73.935242
}

variable "f5xc_cluster_longitude" {
  type    = number
  default = 40.730610
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_token_name" {
  type = string
}

variable "f5xc_namespace" {
  type = string
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
  type = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  type    = bool
  default = false
}

variable "f5xc_ce_slo_enable_secure_sg" {
  type    = bool
  default = false
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
    voltstack = object({
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
      af-south-1     = "ami-0bcfb554a48878b52"
      ap-east-1      = "ami-03cf35954fb9084fc"
      ap-northeast-1 = "ami-07dac882268159d52"
      ap-northeast-2 = "ami-04f6d5781039d2f88"
      ap-northeast-3 = ""
      ap-south-1     = "ami-099c0c7e19e1afd16"
      ap-southeast-1 = "ami-0dba294abe676bd58"
      ap-southeast-2 = "ami-0ae68f561b7d20682"
      ap-southeast-3 = "ami-065fc7b0f6ec02011"
      ca-central-1   = "ami-0ddc009ae69986eb4"
      eu-central-1   = "ami-027625cb269f5d7e9"
      eu-north-1     = "ami-0366c929eb2ac407b"
      eu-south-1     = "ami-00cb6474298a310af"
      eu-west-1      = "ami-01baaca2a3b1b0114"
      eu-west-2      = "ami-05f5a414a42961df6"
      eu-west-3      = "ami-0e1361351f9205511"
      me-south-1     = "ami-0fb5db9d908d231c3"
      sa-east-1      = "ami-09082c4758ef6ec36"
      us-east-1      = "ami-0f94aee77d07b0094"
      us-east-2      = "ami-0660aaf7b6edaa980"
      us-west-1      = "ami-0cf44e35e2aecacb4"
      us-west-2      = "ami-0cba83d31d405a8f5"
    }
    ingress_egress_gateway = {
      af-south-1     = "ami-0c22728f79f714ed1"
      ap-east-1      = "ami-0a6cf3665c0612f91"
      ap-northeast-1 = "ami-0384d075a36447e2a"
      ap-northeast-2 = "ami-01472d819351faf92"
      ap-northeast-3 = ""
      ap-south-1     = "ami-0277ab0b4db359c93"
      ap-southeast-1 = "ami-0d6463ee1e3727e84"
      ap-southeast-2 = "ami-03ff18dfb7f90eb54"
      ap-southeast-3 = "ami-0189e67b4c856e4cd"
      ca-central-1   = "ami-052252c245ff77338"
      eu-central-1   = "ami-06d5e0073d97ecf99"
      eu-north-1     = "ami-006c465449ed98c69"
      eu-south-1     = "ami-0baafa10ffcd081b7"
      eu-west-1      = "ami-090680f491ad6d46a"
      eu-west-2      = "ami-0df8a483722043a41"
      eu-west-3      = "ami-03bd7c41ca1b586a8"
      me-south-1     = "ami-094efc1a78169dd7c"
      sa-east-1      = "ami-07369c4b06cf22299"
      us-east-1      = "ami-089311edbe1137720"
      us-east-2      = "ami-01ba94b5a83adcb35"
      us-west-1      = "ami-092a2a07d2d3a445f"
      us-west-2      = "ami-07252e5ab4023b8cf"
    }
    voltstack = {
      af-south-1     = "ami-055ba977ad1ac6c6c"
      ap-east-1      = "ami-05673740d6f3baee9"
      ap-northeast-1 = "ami-030863f8dfd7029f5"
      ap-northeast-2 = "ami-001dd539455cd4038"
      ap-northeast-3 = ""
      ap-south-1     = "ami-00788bd38d0fa4ff0"
      ap-southeast-1 = "ami-0615e371749491e5f"
      ap-southeast-2 = "ami-0538af7edde340eb1"
      ap-southeast-3 = "ami-0f0c6b2822abb73e2"
      ca-central-1   = "ami-0e1d39ac2c1c6ef2b"
      eu-central-1   = "ami-094c24e0ff9141647"
      eu-north-1     = "ami-0e939f8711e36b456"
      eu-south-1     = "ami-0648b746bb1341bf4"
      eu-west-1      = "ami-01ef385d886b812d2"
      eu-west-2      = "ami-041138a60e1cb4314"
      eu-west-3      = "ami-0e576d6275f207196"
      me-south-1     = "ami-06603c1772bd574c2"
      sa-east-1      = "ami-082f0a654c0936aa5"
      us-east-1      = "ami-0f0926d6b6838b9cb"
      us-east-2      = "ami-0d011fcc6cae3ed0a"
      us-west-1      = "ami-0bec6c226bff67de2"
      us-west-2      = "ami-0d2f1966d883656cd"
    }
  }
}

variable "aws_vpc_cidr_block" {
  type    = string
  default = ""
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