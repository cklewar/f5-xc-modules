variable "is_sensitive" {
  type = bool
}

variable "has_public_ip" {
  type = bool
}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "owner_tag" {
  type = string
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

variable "aws_security_group_rule_slo_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rule_slo_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "4500"
      to_port     = "4500"
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }, {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["172.16.0.0/12"]
    }
  ]
}

variable "aws_security_group_rule_sli_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "aws_security_group_rule_sli_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_api_url" {
  type = string
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
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
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
}

variable "f5xc_aws_region" {
  type = string
}

variable "f5xc_cluster_name" {
  type = string
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
  }
}

variable "aws_vpc_cidr_block" {
  type = string
}

/*variable "f5xc_slo_cidr_block" {
  type = string
}*/

