terraform {
  required_version = ">= 1.7.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.38"
    }

    restful = {
      source  = "magodo/restful"
      version = ">= 0.16.1"
    }

    http-full = {
      source  = "salrashid123/http-full"
      version = ">= 1.3.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.109.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}