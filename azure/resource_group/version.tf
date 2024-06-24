terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.48.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}