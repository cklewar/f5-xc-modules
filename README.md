# F5-XC-MODULES v0.11.14

This repository consists of Terraform template modules to bring up various F5XC components.

# Table of Contents

- [Usage](#usage)
- [F5XC Modules](#f5xc-modules)
- [AWS Modules](#aws-modules)
- [GCP Modules](#gcp-modules)
- [Azure Modules](#azure-modules)

# Usage

- The Terraform templates in this repository ment to be used as modules in any root Terraform template environment
- Create a new Terraform project e.g. __f5xc-mcn__
- Clone this repo with: `git clone -b 0.11.14 https://github.com/cklewar/f5-xc-modules` into the new created project folder
- Export P12 cert file password as environment variable: `export VES_P12_PASSWORD=MyPassword`

Folder structure example:

```bash
.
├── cert
└── modules
└── ck.tf
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

# F5XC Uses Cases

| Use Case                | Documentation                                                                                           | Status                                                                                                                                                                                                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| NFV BigIP               | **[uc_nfv_bigip](https://github.com/cklewar/f5-xc-nfv-bigip)**                                          | [![F5XC NFV module](https://github.com/cklewar/f5-xc-nfv/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-nfv/actions/workflows/module_test.yml)                                                                                      |
| Azure Hub/Spoke Peering | **[uc_azure_vnet_hub_spoke_peering](https://github.com/cklewar/f5-xc-uc-azure-vnet-hub-spoke-peering)** | [![F5XC Azure VNET Hub and Spoke Peering module](https://github.com/cklewar/f5-xc-uc-azure-vnet-hub-spoke-peering/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-uc-azure-vnet-hub-spoke-peering/actions/workflows/module_test.yml) |
| AWS Azure GCP Lab       | **[uc_aws_azure_gcp_lab](https://github.com/cklewar/f5-xc-uc-aws-azure-gcp-lab/tree/0.11.14)**          | [![F5XC AWS Azure GCP lab use case module](https://github.com/cklewar/f5-xc-uc-aws-azure-gcp-lab/actions/workflows/module_test.yml/badge.svg?branch=0.11.14)](https://github.com/cklewar/f5-xc-uc-aws-azure-gcp-lab/actions/workflows/module_test.yml)                          |

# F5XC Modules

| Module             | Documentation                                                                     | Status                                                                                                                                                                                                                               |
|--------------------|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Blindfold          | **[f5xc_api_blindfold](https://github.com/cklewar/f5-xc-blindfold)**              | [![F5XC Blindfold module](https://github.com/cklewar/f5-xc-blindfold/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-blindfold/actions/workflows/module_test.yml)                         |
| API Credential     | **[f5xc_api_credential](https://github.com/cklewar/f5-xc-api-credential)**        | [![F5XC API credential module](https://github.com/cklewar/f5-xc-api-credential/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-api-credential/actions/workflows/module_test.yml)          |
| DC Cluster Group   | **[f5xc_dc_cluster_group](https://github.com/cklewar/f5-xc-dc-cluster-group)**    | [![F5XC DC Cluster module](https://github.com/cklewar/f5-xc-dc-cluster-group/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-dc-cluster-group/actions/workflows/module_test.yml)          |
| Namespace          | **[f5xc_namespace](https://github.com/cklewar/f5-xc-namespace)**                  | [![F5XC namespace module](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-namespace/actions/workflows/module_test.yml)                                     |
| Origin Pool        | **[f5xc_origin_pool](https://github.com/cklewar/f5-xc-origin-pool/tree/0.11.14)** | [![F5XC Origin Pool module](https://github.com/cklewar/f5-xc-origin-pool/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-origin-pool/actions/workflows/module_test.yml)                               |
| LoadBalancer       | **[f5xc_loadbalancer](https://github.com/cklewar/f5-xc-loadbalancer)**            | [![F5XC Load Balancer module](https://github.com/cklewar/f5-xc-loadbalancer/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-loadbalancer/actions/workflows/module_test.yml)               |
| BGP                | **[f5xc_bgp](https://github.com/cklewar/f5-xc-bgp)**                              | [![F5XC BGP module](https://github.com/cklewar/f5-xc-bgp/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-bgp/actions/workflows/module_test.yml)                                                       |
| Fleet              | **[f5xc_fleet](https://github.com/cklewar/f5-xc-fleet)**                          | [![F5XC Fleet module](https://github.com/cklewar/f5-xc-fleet/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-fleet/actions/workflows/module_test.yml)                                                 |
| HealthCheck        | **[f5xc_healthcheck](https://github.com/cklewar/f5-xc-healthcheck)**              | [![F5XC Healthcheck module](https://github.com/cklewar/f5-xc-healthcheck/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-healthcheck/actions/workflows/module_test.yml)                               |
| Virtual Kubernetes | **[f5xc_vk8s](https://github.com/cklewar/f5-xc-virtual-k8s/tree/0.11.14)**        | [![F5XC Virtual Kubernetes module](https://github.com/cklewar/f5-xc-virtual-k8s/actions/workflows/module_test.yml/badge.svg?branch=0.11.14)](https://github.com/cklewar/f5-xc-virtual-k8s/actions/workflows/module_test.yml)         |
| Site Mesh Group    | **[f5xc_site_mesh_group](https://github.com/cklewar/f5-xc-site-mesh-group)**      | [![F5XC Site Mesh Group module](https://github.com/cklewar/f5-xc-site-mesh-group/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-site-mesh-group/actions/workflows/module_test.yml)                   |
| Interface          | **[f5xc_interface](https://github.com/cklewar/f5-xc-interface)**                  | [![F5XC Interface module](https://github.com/cklewar/f5-xc-interface/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-interface/actions/workflows/module_test.yml)                                     |
| NFV                | **[f5xc_nfv](https://github.com/cklewar/f5-xc-nfv)**                              | [![F5XC NFV module](https://github.com/cklewar/f5-xc-nfv/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-nfv/actions/workflows/module_test.yml)                                           |
| IPSec              | **[f5xc_ipsec](https://github.com/cklewar/f5-xc-ipsec)**                          | [![F5XC IPSec module](https://github.com/cklewar/f5-xc-ipsec/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-ipsec/actions/workflows/module_test.yml)                                                 |
| Virtual Network    | **[f5xc_virtual_network](https://github.com/cklewar/f5-xc-virtual-network)**      | [![F5XC Virtual Network module](https://github.com/cklewar/f5-xc-virtual-network/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-virtual-network/actions/workflows/module_test.yml)                   |
| -----              | ------                                                                            | ------                                                                                                                                                                                                                               |
| AWS VPC            | **[f5xc_aws_vpc](https://github.com/cklewar/f5-xc-aws-vpc-multinode)**            | [![F5XC AWS VPC Site module](https://github.com/cklewar/f5-xc-aws-vpc-multinode/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-aws-vpc-multinode/actions/workflows/module_test.yml)      |
| AWS TGW            | **[f5xc_aws_tgw](https://github.com/cklewar/f5-xc-aws-tgw-multinode)**            | [![F5XC AWS TGW module](https://github.com/cklewar/f5-xc-aws-tgw-multinode/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-aws-tgw-multinode/actions/workflows/module_test.yml)                       |
| Azure VNET         | **[f5xc_azure_vnet](https://github.com/cklewar/f5-xc-azure-vnet-multinode)**      | [![F5XC Azure VNET module](https://github.com/cklewar/f5-xc-azure-vnet-multinode/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-azure-vnet-multinode/actions/workflows/module_test.yml)  |
| GCP VPC            | **[f5xc_gcp_vpc](https://github.com/cklewar/f5-xc-gcp-vpc-multinode)**            | [![F5XC GCP VPC Site module](https://github.com/cklewar/f5-xc-gcp-vpc-multinode/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-gcp-vpc-multinode/actions/workflows/module_test.yml)      |
| Virtual Site       | **[f5xc_virtual_site](https://github.com/cklewar/f5-xc-virtual-site)**            | [![F5XC Virtual Site module](https://github.com/cklewar/f5-xc-virtual-site/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/f5-xc-virtual-site/actions/workflows/module_test.yml)                            |
| -----              | -----                                                                             | -----                                                                                                                                                                                                                                |
| Update Object      |                                                                                   |                                                                                                                                                                                                                                      | 
| Site Status Check  | **[f5xc_site_status_check](https://github.com/cklewar/f5-xc-site-status-check)**  | [![F5XC site status check module](https://github.com/cklewar/f5-xc-site-status-check/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-site-status-check/actions/workflows/module_test.yml) |
| vk8s Status Check  | **[f5xc_vk8s_status_check](https://github.com/cklewar/f5-xc-vk8s-status-check)**  | [![F5XC vk8s status check module](https://github.com/cklewar/f5-xc-vk8s-status-check/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/f5-xc-vk8s-status-check/actions/workflows/module_test.yml) |
| NFV Status Check   |                                                                                   |                                                                                                                                                                                                                                      |

# AWS Modules

| Module | Documentation                                           | Status                                                                                                                                                                                      |
|--------|---------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| EC2    | **[aws_ec2](https://github.com/cklewar/aws-ec2)**       | [![F5 XC AWS EC2 module](https://github.com/cklewar/aws-ec2/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/aws-ec2/actions/workflows/module_test.yml) |
| VPC    | **[aws_vpc](https://github.com/cklewar/aws-vpc)**       | [![AWS VPC module](https://github.com/cklewar/aws-vpc/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/aws-vpc/actions/workflows/module_test.yml)                   |
| Subnet | **[aws_subnet](https://github.com/cklewar/aws-subnet)** | [![AWS Subnet module](https://github.com/cklewar/aws-subnets/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/aws-subnets/actions/workflows/module_test.yml)        |
| EKS    | **[aws_eks](https://github.com/cklewar/aws-eks)**       |                                                                                                                                                                                             |

# GCP Modules

| Module  | Documentation                                              | Status                                                                                                                                                                                             |
|---------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Compute | **[gcp_compute](https://github.com/cklewar/gcp-compute/)** | [![GCP Compute module](https://github.com/cklewar/gcp-compute/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/gcp-compute/actions/workflows/module_test.yml)  |
|         |                                                            |                                                                                                                                                                                                    |

# Azure Modules

| Module                | Documentation                                                                              | Status                                                                                                                                                                                                                                            |
|-----------------------|--------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Linux Virtual Machine | **[azure_linux_virtual_machine](https://github.com/cklewar/azure-linux-virtual-machine/)** | [![Azure linux virtual machine module](https://github.com/cklewar/azure-linux-virtual-machine/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/azure-linux-virtual-machine/actions/workflows/module_test.yml) |
| Resource Group        | **[azure_resource_group](https://github.com/cklewar/azure-resource-group )**               | [![Azure resource group module](https://github.com/cklewar/azure-resource-group/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/azure-resource-group/actions/workflows/module_test.yml)                      |
| Virtual Network       | **[azure_virtual_network](https://github.com/cklewar/azure-virtual-network/)**             | [![Azure virtual network module](https://github.com/cklewar/azure-virtual-network/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/azure-virtual-network/actions/workflows/module_test.yml)                   |
| Subnet                | **[azure_subnet](https://github.com/cklewar/azure-subnet )**                               | [![Azure subnet module](https://github.com/cklewar/azure-subnet/actions/workflows/module_test.yml/badge.svg?branch=main)](https://github.com/cklewar/azure-subnet/actions/workflows/module_test.yml)                                              |
| Marketplace Agreement | **[azure_marketplace_agreement](https://github.com/cklewar/azure-marketplace-agreement/)** | [![Azure marketplace agreement module](https://github.com/cklewar/azure-marketplace-agreement/actions/workflows/module_test.yml/badge.svg)](https://github.com/cklewar/azure-marketplace-agreement/actions/workflows/module_test.yml)             |
