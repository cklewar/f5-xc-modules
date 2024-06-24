terraform {
  required_version = ">= 1.7.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.32"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}