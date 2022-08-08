terraform {
  required_version = ">= 1.2.5"

  required_providers {

    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.9"
    }

    bigip = {
      source  = "F5Networks/bigip"
      version = ">= 1.14.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}