variable "is_sensitive" {
  description = "mark module output as sensitive"
  type        = bool
}

variable "owner_tag" {
  description = "set a tag called owner"
  type        = string
}

variable "f5xc_cluster_name" {
  description = "F5XC Site / Cluster name"
  type        = string
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
  default     = ""
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
}

variable "f5xc_aws_region" {
  description = "AWS region"
  type        = string
}

variable "f5xc_cluster_nodes" {
  type = map(map(map(string)))
  validation {
    condition = length(var.f5xc_cluster_nodes.master) == 1 && length(var.f5xc_cluster_nodes.worker) == 0 || length(var.f5xc_cluster_nodes.master) == 3 && length(var.f5xc_cluster_nodes.worker) >= 0 || length(var.f5xc_cluster_nodes.master) == 0
    error_message = "Supported master / worker nodes: master 1 and no worker, master 3 and <n> worker"
  }
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["voltstack_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: voltstack_gateway")
  }
}

variable "f5xc_ce_hosts_public_name" {
  type    = string
  default = "vip"
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

variable "create_new_aws_vpc" {
  description = "create new aws vpc"
  type        = bool
  default     = true
}

variable "aws_vpc_cidr_block" {
  description = "AWS vpc CIDR block"
  type        = string
  default     = ""
}

variable "aws_existing_vpc_id" {
  description = "inject existing aws vpc id"
  type        = string
  default     = ""
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

variable "f5xc_site_type_is_secure_mesh_site" {
  type    = bool
  default = true
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
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

variable "aws_instance_type_master" {
  type = string
}

variable "aws_instance_type_worker" {
  type = string
}

variable "has_public_ip" {
  description = "whether the CE gets a public IP assigned to SLO"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  type = string
}