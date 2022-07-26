terraform {
  required_version = ">= 0.13.7"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.09"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}