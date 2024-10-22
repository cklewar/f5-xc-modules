variable "is_sensitive" {
  description = "mark module output as sensitive"
  type        = bool
}

variable "wait_for_online" {
  type        = bool
  default     = true
  description = "enable wait_for_online status check. This will wait till CE fully operational"
}

variable "status_check_type" {
  type    = string
  default = "token"
  validation {
    condition = contains(["token", "cert"], var.status_check_type)
    error_message = format("Valid values for status_check_type: token or cert")
  }
}

variable "has_public_ip" {
  description = "whether the CE gets a public IP assigned to SLO"
  type        = bool
  default     = true
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

variable "create_new_aws_igw" {
  description = "create new aws igw"
  type        = bool
  default     = true
}

variable "create_new_aws_iam_profile" {
  description = "create new AWS IAM profile with mandatory actions"
  type        = string
  default     = true

}

variable "create_new_aws_slo_rt" {
  description = "create new slo subnet route table"
  type        = bool
  default     = true
}

variable "create_new_aws_sli_rt" {
  description = "create new sli subnet route table"
  type        = bool
  default     = true
}

variable "create_new_aws_slo_rta" {
  description = "create new slo aws route table association"
  type        = bool
  default     = true
}

variable "create_new_aws_sli_rta" {
  description = "create new sli aws route table association"
  type        = bool
  default     = true
}

variable "create_new_slo_security_group" {
  description = "create new aws F5XC CE SLO security group"
  type        = bool
  default     = true
}

variable "create_new_sli_security_group" {
  description = "create new aws F5XC CE SLI security group"
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
  description = "New EC2 instance assigned public ssh key"
  type        = string
  default     = null
}

variable "aws_instance_type" {
  description = "AWS EC2 instance flavour"
  type        = string
}

variable "aws_existing_key_pair_id" {
  description = "existing AWS ssh object id"
  type        = string
  default     = null
}

variable "aws_slo_rt_custom_ipv4_routes" {
  description = "Add custom ipv4 routes to aws slo rt table"
  type = list(object({
    cidr_block = string
    gateway_id = optional(string)
    network_interface_id = optional(string)
  }))
  default = []
}

variable "aws_slo_rt_custom_ipv6_routes" {
  description = "Add custom ipv6 routes to aws slo rt table"
  type = list(object({
    cidr_block = string
    gateway_id = optional(string)
    network_interface_id = optional(string)
  }))
  default = []
}

variable "aws_existing_vpc_id" {
  description = "inject existing aws vpc id"
  type        = string
  default     = ""
}


variable "aws_existing_sg_slo_ids" {
  description = "inject list of existing security group ids for SLO"
  type = list(string)
  default = []
}

variable "aws_existing_sg_sli_ids" {
  description = "inject list of existing security group ids for SLI"
  type = list(string)
  default = []
}

variable "aws_existing_iam_profile_name" {
  description = "Create new AWS IAM profile for CE with mandatory actions"
  type        = string
  default     = null
}

variable "aws_security_group_rules_slo_egress_default" {
  description = "default aws security groups assigned to slo egress"
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
  description = "default aws security groups assigned to slo ingress"
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
  description = "aws security groups assigned to sli egress"
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
  description = "aws security groups assigned to sli ingress"
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
  description = "provide custom aws security groups assigned to slo egress"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_ingress" {
  description = "provide custom aws security groups assigned to slo ingress"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_egress" {
  description = "provide custom aws security groups assigned to sli egress"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "aws_security_group_rules_sli_ingress" {
  description = "provide custom aws security groups assigned to sli ingress"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "aws_key_pair_id" {
  description = "The ID of existing AWS ssh key pair"
  type        = string
  default     = null
}

variable "aws_iam_policy_id" {
  description = "THe ID of existing AWS IAM policy"
  type        = string
  default     = null
}

variable "f5xc_cluster_labels" {
  description = "F5 XC CE Cluster labels"
  type = map(string)
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

variable "f5xc_api_p12_file" {
  description = "F5 XC api ca cert"
  type        = string
  default     = ""
}

variable "f5xc_api_token" {
  description = "F5 XC api token"
  type        = string
  default     = ""
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
    condition = contains(["ingress_egress_gateway", "ingress_gateway", "voltstack"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway, voltstack")
  }
}

variable "f5xc_ce_to_re_tunnel_type" {
  description = "CE to RE tunnel type"
  type        = string
  validation {
    condition = contains(["ssl", "ipsec"], var.f5xc_ce_to_re_tunnel_type)
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

variable "f5xc_cluster_default_blocked_services" {
  type    = bool
  default = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_enable_offline_survivability_mode" {
  type    = bool
  default = false
}

variable "f5xc_api_p12_cert_password" {
  description = "XC API cert file password used later in status module to retrieve site status"
  type        = string
  default     = ""
}

variable "f5xc_is_secure_cloud_ce" {
  description = "whether CE should be secured by applying security rules on SLO and SLI + NAT GW + SLO private IP"
  type        = bool
  default     = false
}

variable "f5xc_is_private_cloud_ce" {
  description = "whether CE should be private with SLO has private IP and NAT GW in front"
  type        = bool
  default     = false
}

variable "f5xc_ce_slo_enable_secure_sg" {
  description = "whether CE should be secured by applying security rules on SLO"
  type        = bool
  default     = false
}

variable "f5xc_secure_mesh_site_version" {
  type    = number
  default = 2
  validation {
    condition = contains([1, 2], var.f5xc_secure_mesh_site_version)
    error_message = "f5xc_secure_mesh_site_version must be 1 or 2"
  }
}

variable "f5xc_sms_provider_name" {
  type    = string
  default = null
}

variable "f5xc_sms_master_nodes_count" {
  type    = number
  default = 1
}

variable "f5xc_ce_machine_image" {
  type = object({
    ingress_gateway = object({
      af-south-1     = string
      ap-south-1     = string
      eu-north-1     = string
      eu-west-3      = string
      eu-south-1     = string
      eu-west-2      = string
      eu-west-1      = string
      ap-northeast-3 = string
      ap-northeast-2 = string
      me-south-1     = string
      ap-northeast-1 = string
      ca-central-1   = string
      sa-east-1      = string
      ap-east-1      = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      eu-central-1   = string
      ap-southeast-3 = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
    ingress_egress_gateway = object({
      af-south-1     = string
      ap-south-1     = string
      eu-north-1     = string
      eu-west-3      = string
      eu-south-1     = string
      eu-west-2      = string
      eu-west-1      = string
      ap-northeast-3 = string
      ap-northeast-2 = string
      me-south-1     = string
      ap-northeast-1 = string
      ca-central-1   = string
      sa-east-1      = string
      ap-east-1      = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      eu-central-1   = string
      ap-southeast-3 = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
    voltstack_gateway = object({
      af-south-1     = string
      ap-south-1     = string
      eu-north-1     = string
      eu-west-3      = string
      eu-south-1     = string
      eu-west-2      = string
      eu-west-1      = string
      ap-northeast-3 = string
      ap-northeast-2 = string
      me-south-1     = string
      ap-northeast-1 = string
      ca-central-1   = string
      sa-east-1      = string
      ap-east-1      = string
      ap-southeast-1 = string
      ap-southeast-2 = string
      eu-central-1   = string
      ap-southeast-3 = string
      us-east-1      = string
      us-east-2      = string
      us-west-1      = string
      us-west-2      = string
    })
  })
  default = {
    ingress_gateway = {
      af-south-1     = "ami-0dd7a6da7161c6940"
      ap-south-1     = "ami-04f4b057cdfae232d"
      eu-north-1     = "ami-0323204b43cf4427d"
      eu-west-3      = "ami-0f67f2b80eaff5e6a"
      eu-south-1     = "ami-02cbc50164cd05e7a"
      eu-west-2      = "ami-09408cd0d39d087ad"
      eu-west-1      = "ami-03c875b9908e04737"
      ap-northeast-3 = "ami-0e549fd46bc34dad9"
      ap-northeast-2 = "ami-03ee4e9dc5a895538"
      me-south-1     = "ami-0ff52d8834a2ed9fe"
      ap-northeast-1 = "ami-021a8e03b83a767ab"
      ca-central-1   = "ami-0bad12be22379f9a6"
      sa-east-1      = "ami-05b23bc6cf1649e0a"
      ap-east-1      = "ami-0616b484a4b48fe34"
      ap-southeast-1 = "ami-0bfa8b0ab593b8ea5"
      ap-southeast-2 = "ami-0bd25bc1d097e57aa"
      eu-central-1   = "ami-0b0912acc6a94069b"
      ap-southeast-3 = "ami-08475b5dcdae8312d"
      us-east-1      = "ami-044129a2ee46c520d"
      us-east-2      = "ami-05dd49c52b2c70521"
      us-west-1      = "ami-0cbbd212f1ad3985f"
      us-west-2      = "ami-0fef0232e8ae0526c"
    }
    ingress_egress_gateway = {
      af-south-1     = "ami-0cc40407dc7f37181"
      ap-south-1     = "ami-06b385417fa451722"
      eu-north-1     = "ami-0483fe084eb50dd66"
      eu-west-3      = "ami-051b65a85e55301d9"
      eu-south-1     = "ami-0d787b83a9953bf14"
      eu-west-2      = "ami-0c962ac76daf1169e"
      eu-west-1      = "ami-0e91e46737f405e1d"
      ap-northeast-3 = "ami-0ab73daa18a7bd36e"
      ap-northeast-2 = "ami-0c8257eded5e2d003"
      me-south-1     = "ami-0c90549a67445f5b3"
      ap-northeast-1 = "ami-028b0818222aac4aa"
      ca-central-1   = "ami-06c85c3c80280301a"
      sa-east-1      = "ami-0015a055fee534331"
      ap-east-1      = "ami-01d124c67d70ed00f"
      ap-southeast-1 = "ami-02a5c37f336eadc48"
      ap-southeast-2 = "ami-03e3dc8a8d24cfb18"
      eu-central-1   = "ami-0153cf2bf0c44ce6c"
      ap-southeast-3 = "ami-0388582a0237a67ed"
      us-east-1      = "ami-06946ea511e23ce70"
      us-east-2      = "ami-0393e8d226f4a7834"
      us-west-1      = "ami-0e09c5ea5ee807f6b"
      us-west-2      = "ami-0a05f2c70c4203b8f"
    }
    voltstack_gateway = {
      af-south-1     = "ami-038b4b28b296f2c05"
      ap-south-1     = "ami-0b26483209bc17b3b"
      eu-north-1     = "ami-06883f5fd89044a3c"
      eu-west-3      = "ami-06bee04255e5363c5"
      eu-south-1     = "ami-038830d26f31bf5a1"
      eu-west-2      = "ami-09d5c89de31788d9c"
      eu-west-1      = "ami-0220aa19a3043c363"
      ap-northeast-3 = "ami-0199149abed7da517"
      ap-northeast-2 = "ami-07b43f4cdb8de076d"
      me-south-1     = "ami-0284ffd2753acddc4"
      ap-northeast-1 = "ami-01d252e0de4fb4fc9"
      ca-central-1   = "ami-003ad6a838aefd8e4"
      sa-east-1      = "ami-038e519d52ab7ae4a"
      ap-east-1      = "ami-0f5694296b07c7432"
      ap-southeast-1 = "ami-092e0f7d7cb269dc7"
      ap-southeast-2 = "ami-0ab4517d461a73c0e"
      eu-central-1   = "ami-000151f67563f0b5e"
      ap-southeast-3 = "ami-00f5b0b2266a95fde"
      us-east-1      = "ami-08d455e7350ea38c9"
      us-east-2      = "ami-06da3b6b3f8ffe439"
      us-west-1      = "ami-02bb20e5fb2e5f0aa"
      us-west-2      = "ami-073716a5d00689881"
    }
  }
}

variable "f5xc_ce_performance_enhancement_mode" {
  type = object({
    perf_mode_l7_enhanced = bool
    perf_mode_l3_enhanced = optional(object({
      jumbo_frame_enabled = bool
    }))
  })
  default = {
    perf_mode_l7_enhanced = true
  }
}

variable "aws_vpc_cidr_block" {
  description = "AWS vpc CIDR block"
  type        = string
  default     = ""
}

variable "f5xc_ip_ranges_Americas_TCP" {
  type = list(string)
  default = [
    "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25",
    "23.158.32.0/25",
  ]
}
variable "f5xc_ip_ranges_Americas_UDP" {
  type = list(string)
  default = [
    "23.158.32.0/25", "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25",
    "84.54.61.0/25",
  ]
}
variable "f5xc_ip_ranges_Europe_TCP" {
  type = list(string)
  default = [
    "84.54.60.0/25", "185.56.154.0/25", "159.60.162.0/24", "159.60.188.0/24", "5.182.212.0/25", "5.182.214.0/25",
    "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25",
  ]
}
variable "f5xc_ip_ranges_Europe_UDP" {
  type = list(string)
  default = [
    "5.182.212.0/25", "185.56.154.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25", "5.182.214.0/25",
    "84.54.60.0/25", "159.60.162.0/24", "159.60.188.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_TCP" {
  type = list(string)
  default = [
    "103.135.56.0/25", "103.135.56.128/25", "103.135.58.128/25", "159.60.189.0/24", "159.60.166.0/24",
    "103.135.57.0/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.164.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_UDP" {
  type = list(string)
  default = [
    "103.135.57.0/25", "103.135.56.128/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.166.0/24", "159.60.164.0/24",
    "103.135.56.0/25", "103.135.58.128/25", "159.60.189.0/24",
  ]
}

variable "f5xc_ce_egress_ip_ranges" {
  type = list(string)
  description = "Egress IP ranges for F5 XC CE"
  default = [
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