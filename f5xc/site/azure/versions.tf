terraform {
  required_version = ">= 1.3.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.16"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.26.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}