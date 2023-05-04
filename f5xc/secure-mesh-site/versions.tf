terraform {
  required_version = ">= 1.3.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.21"
    }
    
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.51.0"
    }

    restapi = {
      source  = "Mastercard/restapi"
      version = "1.18.0"
    }

    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.3.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 4.48.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}