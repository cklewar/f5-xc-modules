terraform {
  required_version = ">= 1.2.7"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.21.1"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}