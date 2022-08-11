# F5-XC-MODULES

This repository consists of Terraform template modules to bring up various F5XC components.

# Table of Contents

- [Usage](#usage)
- [F5XC Modules](#f5xc-modules)
  * [Virtual Kubernetes](#virtual-kubernetes)
  * [NFV](#nfv)
  * [Site](#site)
    + [Update](#update)
    + [Site Status Check](#site-status-check)
- [AWS Modules](#aws-modules)
- [GCP Modules](#gcp-modules)
- [Azure Modules](#azure-modules)

# Usage

- The Terraform templates in this repository ment to be used as modules in any root Terraform template environment
- Create a new Terraform project e.g. __f5xc-mcn__
- Clone this repo with: `git clone https://github.com/cklewar/f5-xc-modules` into the new created project folder
- Export P12 cert file password as environment variable: `export VES_P12_PASSWORD=MyPassword`

Folder structure example:

```bash
.
├── cert
└── modules
└── main.tf
```

Terraform usage example:

```hcl
module "my_test_modul" {
  source = "./modules/f5xc/<module_name>"
  <Module Paramet A> = <Module Paramet A Value>
  <Module Paramet B> = <Module Paramet B Value>
  <Module Paramet C> = <Module Paramet C Value>
}
```

# F5XC Modules

| Module             | Documentation                                                                       | Validate                                                                                                                                                                                                              | Plan                                                                                                                                                                                              | Apply                                                                                                                                                                                              | Destroy             |
|--------------------|-------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| DC Cluster Group   | **[f5xc_dcg_module](https://github.com/cklewar/f5-xc-dc-cluster-group)**            | [![F5XC DC Cluster Group module](https://github.com/cklewar/f5-xc-dc-cluster-group/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-dc-cluster-group/actions/workflows/module_test.yml) |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Namespace          | **[f5xc_namespace_module](https://github.com/cklewar/f5-xc-namespace)**             | [![F5XC namespace module](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml)                      | [![F5XC namespace module](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml)  | [![F5XC namespace module](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml)   |                     |
| Origin Pool        | **[f5xc_fleet_module](https://github.com/cklewar/f5-xc-origin-pool)**               | [![F5XC Origin Pool module](https://github.com/cklewar/f5-xc-origin-pool/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-origin-pool/actions/workflows/module_test.yml)                |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| BGP                | **[f5xc_bgp_module](https://github.com/cklewar/f5-xc-bgp)**                         | [![F5XC BGP module](https://github.com/cklewar/f5-xc-bgp/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-bgp/actions/workflows/module_test.yml)                                        |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Fleet              | **[f5xc_fleet_module](https://github.com/cklewar/f5-xc-fleet)**                     | [![F5XC Fleet module](https://github.com/cklewar/f5-xc-fleet/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-fleet/actions/workflows/module_test.yml)                                  |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| HealthCheck        | **[f5xc_healthcheck_module](https://github.com/cklewar/f5-xc-healthcheck)**         | [![F5XC Healthcheck module](https://github.com/cklewar/f5-xc-healthcheck/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-healthcheck/actions/workflows/module_test.yml)                |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Virtual Kubernetes |                                                                                     |                                                                                                                                                                                                                       |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Site Mesh Group    | **[f5xc_site_mesh_group_module](https://github.com/cklewar/f5-xc-site-mesh-group)** | [![F5XC Site Mesh Group module](https://github.com/cklewar/f5-xc-site-mesh-group/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-site-mesh-group/actions/workflows/module_test.yml)    |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Interface          | **[f5xc_interface_module](https://github.com/cklewar/f5-xc-interface)**             | [![F5XC Interface module](https://github.com/cklewar/f5-xc-interface/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-interface/actions/workflows/module_test.yml)                      |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| NFV                |                                                                                     |                                                                                                                                                                                                                       |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| IPSec              | **[f5xc_ipsec_module](https://github.com/cklewar/f5-xc-ipsec)**                     | [![F5XC IPSec module](https://github.com/cklewar/f5-xc-ipsec/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-ipsec/actions/workflows/module_test.yml)                                  |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Virtual Network    | **[f5xc_virtual_network_module](https://github.com/cklewar/f5-xc-virtual-network)** | [![F5XC Virtual-Network module](https://github.com/cklewar/f5-xc-virtual-network/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-virtual-network/actions/workflows/module_test.yml)    |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| -----              | ------                                                                              | ------                                                                                                                                                                                                                |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| AWS VPC            | **[f5xc_aws_vpc_module](https://github.com/cklewar/f5-xc-aws-vpc-multinode)**       | [![F5XC AWS VPC module](https://github.com/cklewar/f5-xc-aws-vpc-multinode/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-aws-vpc-multinode/actions/workflows/module_test.yml)        |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| AWS TGW            | **[f5xc_aws_tgw_module](https://github.com/cklewar/f5-xc-aws-tgw-multinode)**       | [![F5XC AWS TGW module](https://github.com/cklewar/f5-xc-aws-tgw-multinode/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-aws-tgw-multinode/actions/workflows/module_test.yml)        |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Azure VNET         | **[f5xc_azure_vnet_module](https://github.com/cklewar/f5-xc-azure-vnet-multinode)** | [![F5XC Azure VNET module](https://github.com/cklewar/f5-xc-azure-vnet-multinode/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-azure-multinode/actions/workflows/module_test.yml)    |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| GCP VPC            | **[f5xc_gcp_vpc_module](https://github.com/cklewar/f5-xc-gcp-vpc-multinode)**       | [![F5XC GCP VPC module](https://github.com/cklewar/f5-xc-gcp-multinode/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-gcp-multinode/actions/workflows/module_test.yml)                |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Virtual Site       | **[f5xc_virtual_site_module](https://github.com/cklewar/f5-xc-virtual_site)**       | [![F5XC Virtual Site module](https://github.com/cklewar/f5-xc-virtual-site/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-virtual-site/actions/workflows/module_test.yml)             |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Update             |                                                                                     |                                                                                                                                                                                                                       |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     | 
|                    |                                                                                     |                                                                                                                                                                                                                       |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |
| Site Status Check  |                                                                                     |                                                                                                                                                                                                                       |                                                                                                                                                                                                   |                                                                                                                                                                                                    |                     |

## Virtual Kubernetes

__Module Usage Example__

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

module "vk8s" {
  source                              = "./modules/f5xc/vk8s"
  f5xc_f5xc_site_mesh_group_name_name = format("%s-vk8s-%s", var.project_prefix, var.project_suffix)
  f5xc_virtual_site_refs              = ["vSiteA"]
  kubectl_secret_registry_type        = "docker-registry"
  kubectl_secret_registry_server      = "docker.io"
  kubectl_secret_name                 = "regcred"
  kubectl_secret_registry_username    = "admin"
  kubectl_secret_registry_password    = "password"
  kubectl_secret_registry_email       = "admin@example.net"
  f5xc_namespace                      = var.f5xc_namespace
  f5xc_tenant                         = var.f5xc_tenant
  f5xc_api_url                        = var.f5xc_api_url
  f5xc_api_p12_file                   = var.f5xc_api_p12_file
}
```
## NFV

__Module Usage Example__

This module needs a F5XC AWS TGW site to be deployed first since it depends on F5XC TGW input data.

````hcl
module "nfv" {
  source                    = "./modules/f5xc/nfv"
  dependency                = module.tgw.this
  f5xc_project_prefix       = var.project_prefix
  f5xc_project_suffix       = var.project_suffix
  f5xc_tenant               = var.data[terraform.workspace].tenant
  f5xc_namespace            = var.namespace
  aws_region                = var.aws_region
  f5xc_api_p12_file         = var.data[terraform.workspace].api_p12_file
  f5xc_api_ca_cert          = var.f5xc_api_ca_cert
  f5xc_api_token            = var.data[terraform.workspace].api_token
  f5xc_api_cert             = var.f5xc_api_cert
  f5xc_api_key              = var.f5xc_api_key
  f5xc_api_url              = var.data[terraform.workspace].api_url
  aws_az_name               = var.aws_az_name
  tgw_name                  = format("%s-%s-%s", var.project_prefix, var.tgw_name, var.project_suffix)
  f5xc_nfv_name             = format("%s-%s-%s", var.project_prefix, var.f5xc_nfv_name, var.project_suffix)
  f5xc_nfv_node_name        = format("%s-%s-%s", var.project_prefix, var.f5xc_nfv_node_name, var.project_suffix)
  f5xc_nfv_admin_username   = var.f5xc_nfv_admin_username
  f5xc_nfv_admin_password   = base64encode(var.f5xc_nfv_admin_password)
  f5xc_nfv_domain_suffix    = var.data[terraform.workspace].nfv_domain_suffix
  f5xc_nfv_description      = var.f5xc_nfv_description
  f5xc_nfv_payload_file     = var.f5xc_nfv_payload_file
  f5xc_nfv_payload_template = var.f5xc_nfv_payload_template
  f5xc_nfv_svc_create_uri   = var.f5xc_nfv_svc_create_uri
  f5xc_nfv_svc_delete_uri   = var.f5xc_nfv_svc_delete_uri
  f5xc_nfv_svc_get_uri      = var.f5xc_nfv_svc_get_uri
  aws_owner_tag             = var.data[terraform.workspace].owner_tag
  public_ssh_key            = var.public_ssh_key
}
````

## Site

### Update

__Module Usage Example__

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

locals {
  deployment     = format("%s-%s", var.project_prefix, var.project_suffix)
  cluster_labels = var.fleet_label != "" ? { "ves.io/fleet" = var.fleet_label } : {}
  global_vn_name = format("my-global-vn-%s", var.project_suffix)
}

module "site_update" {
  source                      = "./modules/f5xc/site/update"
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_namespace              = var.f5xc_namespace
  f5xc_api_p12_file           = var.f5xc_api_p12_file
  f5xc_api_token              = var.f5xc_api_token
  f5xc_api_url                = var.f5xc_api_url
  f5xc_global_virtual_network = local.global_vn_name
  f5xc_site_name              = local.deployment
  f5xc_cluster_labels         = local.cluster_labels
}
```

---------------------

### Site Status Check

__Module Usage Example__

````hcl
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

variable "f5xc_site_name" {
  type = string
}

module "site_status_check" {
  source         = "./modules/f5xc/status/site"
  f5xc_api_url   = var.f5xc_api_url
  f5xc_api_token = var.f5xc_api_token
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = var.f5xc_site_name
  f5xc_tenant    = var.f5xc_tenant
}
````

# AWS Modules

| Module | Documentation                                                       | Status                                                                                                                                                                                    |
|--------|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| EC2    | **[f5xc_aws_ec2_module](https://github.com/cklewar/aws-ec2)**       | [![F5XC AWS EC2 module](https://github.com/cklewar/aws-ec2/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/aws-ec2/actions/workflows/module_test.yml)            |
| VPC    | **[f5xc_aws_vpc_module](https://github.com/cklewar/aws-vpc)**       | [![F5XC AWS VPC module](https://github.com/cklewar/aws-vpc/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/aws-vpc/actions/workflows/module_test.yml)            |
| Subnet | **[f5xc_aws_subnet_module](https://github.com/cklewar/aws-subnet)** | [![F5XC AWS Subnet module](https://github.com/cklewar/aws-subnets/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/aws-subnets/actions/workflows/module_test.yml) |
| EKS    |                                                                     |                                                                                                                                                                                           |

# GCP Modules

| Module  | Documentation | Status |
|---------|---------------|--------|
| Compute |               |        |
|         |               |        |

# Azure Modules

| Module                | Documentation | Status   |
|-----------------------|---------------|----------|
| Linux Virtual Machine |               |          |
| Resource Group        |               |          |
| Virtual Network       |               |          |
| Subnet                |               |          |
