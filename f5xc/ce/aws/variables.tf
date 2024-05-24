variable "is_sensitive" {
  description = "mark module output as sensitive"
  type        = bool
}

variable "status_check_type" {
  type    = string
  default = "token"
  validation {
    condition     = contains(["token", "cert"], var.status_check_type)
    error_message = format("Valid values for status_check_type: token or cert")
  }
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

variable "aws_existing_key_pair_id" {
  description = "existing AWS ssh object id"
  type        = string
  default     = null
}

variable "aws_slo_rt_custom_ipv4_routes" {
  description = "Add custom ipv4 routes to aws slo rt table"
  type        = list(object({
    cidr_block           = string
    gateway_id           = optional(string)
    network_interface_id = optional(string)
  }))
  default = []
}

variable "aws_slo_rt_custom_ipv6_routes" {
  description = "Add custom ipv6 routes to aws slo rt table"
  type        = list(object({
    cidr_block           = string
    gateway_id           = optional(string)
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
  type        = list(string)
  default     = []
}

variable "aws_existing_sg_sli_ids" {
  description = "inject list of existing security group ids for SLI"
  type        = list(string)
  default     = []
}

variable "aws_existing_iam_profile_name" {
  description = "Create new AWS IAM profile for CE with mandatory actions"
  type        = string
  default     = null
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

variable "f5xc_site_type_is_secure_mesh_site" {
  type    = bool
  default = true
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
      af-south-1     = "ami-08744facfd887f92d"
      ap-south-1     = "ami-0bda3dcea89c5d041"
      eu-north-1     = "ami-0a825dd646f3ca83c"
      eu-west-3      = "ami-00a508f3ae0166adb"
      eu-south-1     = "ami-0a39703c6fcba60c9"
      eu-west-2      = "ami-07f1671a8acf956af"
      eu-west-1      = "ami-04beae0f9774b8f48"
      ap-northeast-2 = "ami-0dba413f1ae8fed6d"
      me-south-1     = "ami-0dc2ff44f3c6e6f88"
      ap-northeast-1 = "ami-024976a3c31f41cd2"
      ca-central-1   = "ami-0c193c43523268e72"
      sa-east-1      = "ami-030b6602f95c6b41d"
      ap-east-1      = "ami-0f42f00a2a7ccf1b7"
      ap-southeast-1 = "ami-0d8589350ad5b70c7"
      ap-southeast-2 = "ami-069178fb7d4e94257"
      eu-central-1   = "ami-0156dae589b1bd776"
      ap-southeast-3 = "ami-0296f8254cf4fc461"
      us-east-1      = "ami-0aaed44d894a16abd"
      us-east-2      = "ami-072ac5ad86b390ac1"
      us-west-1      = "ami-09e2c941fc144cc64"
      us-west-2      = "ami-0a4218dd27123de5e"
    }
    ingress_egress_gateway = {
      af-south-1     = "ami-023e087f318476ed9"
      ap-south-1     = "ami-024041694fcfbe2dd"
      eu-north-1     = "ami-0345463aff25b88dc"
      eu-west-3      = "ami-0b8c7cdeff7eafcf2"
      eu-south-1     = "ami-0deb487fde00d53c2"
      eu-west-2      = "ami-01277d39e5e4fd47b"
      eu-west-1      = "ami-0c0403f654ab29c83"
      ap-northeast-2 = "ami-0e9545c604fb95caa"
      me-south-1     = "ami-04ee61928cc1d3678"
      ap-northeast-1 = "ami-0fcea17bd7b580959"
      ca-central-1   = "ami-09c004db075caf4ab"
      sa-east-1      = "ami-02f069fe09fae8d76"
      ap-east-1      = "ami-048436483e2554841"
      ap-southeast-1 = "ami-039d3da469422cad1"
      ap-southeast-2 = "ami-044595dc80554906d"
      eu-central-1   = "ami-04720f54d40337fe2"
      ap-southeast-3 = "ami-0e3f3f1ab4b3240e5"
      us-east-1      = "ami-02af1acad1eef7940"
      us-east-2      = "ami-029d17ae8507c9b4a"
      us-west-1      = "ami-0b91438f4f4bc1af9"
      us-west-2      = "ami-0d36a75587461b250"
    }
    voltstack_gateway = {
      af-south-1     = "ami-037b1a1d5ccfe3610"
      ap-south-1     = "ami-08a53309ab95573d6"
      eu-north-1     = "ami-05850a833a8205afc"
      eu-west-3      = "ami-04c05f1e003c8a5b4"
      eu-south-1     = "ami-0155b585d94aa8a47"
      eu-west-2      = "ami-0655eac30ba4816ae"
      eu-west-1      = "ami-04fa0945c604d4106"
      ap-northeast-2 = "ami-09bc0eeba6d90514f"
      me-south-1     = "ami-0941ccabf475035be"
      ap-northeast-1 = "ami-0769202844d44c96b"
      ca-central-1   = "ami-0a4d8c8bc8ca1ab21"
      sa-east-1      = "ami-034b2b063f5bdeeb9"
      ap-east-1      = "ami-05cf4b6e9edb21588"
      ap-southeast-1 = "ami-03be5dbe1fa59a641"
      ap-southeast-2 = "ami-013b0ea6c71800c51"
      eu-central-1   = "ami-07860a3b1ab83ce62"
      ap-southeast-3 = "ami-065d3a99d7a896c70"
      us-east-1      = "ami-0a2121d65c9a600ea"
      us-east-2      = "ami-08762c8bd258c3b30"
      us-west-1      = "ami-0cae9e09eecedfec3"
      us-west-2      = "ami-04b388d0bc88442db"
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
  type    = list(string)
  default = [
    "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25", "84.54.61.0/25",
    "23.158.32.0/25",
  ]
}
variable "f5xc_ip_ranges_Americas_UDP" {
  type    = list(string)
  default = [
    "23.158.32.0/25", "84.54.62.0/25", "185.94.142.0/25", "185.94.143.0/25", "159.60.190.0/24", "5.182.215.0/25",
    "84.54.61.0/25",
  ]
}
variable "f5xc_ip_ranges_Europe_TCP" {
  type    = list(string)
  default = [
    "84.54.60.0/25", "185.56.154.0/25", "159.60.162.0/24", "159.60.188.0/24", "5.182.212.0/25", "5.182.214.0/25",
    "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25",
  ]
}
variable "f5xc_ip_ranges_Europe_UDP" {
  type    = list(string)
  default = [
    "5.182.212.0/25", "185.56.154.0/25", "159.60.160.0/24", "5.182.213.0/25", "5.182.213.128/25", "5.182.214.0/25",
    "84.54.60.0/25", "159.60.162.0/24", "159.60.188.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_TCP" {
  type    = list(string)
  default = [
    "103.135.56.0/25", "103.135.56.128/25", "103.135.58.128/25", "159.60.189.0/24", "159.60.166.0/24",
    "103.135.57.0/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.164.0/24",
  ]
}
variable "f5xc_ip_ranges_Asia_UDP" {
  type    = list(string)
  default = [
    "103.135.57.0/25", "103.135.56.128/25", "103.135.59.0/25", "103.135.58.0/25", "159.60.166.0/24", "159.60.164.0/24",
    "103.135.56.0/25", "103.135.58.128/25", "159.60.189.0/24",
  ]
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