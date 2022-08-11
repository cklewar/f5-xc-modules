terraform {
  required_version = ">= 1.2.7"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.11"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.17.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}