terraform {
  required_version = ">= 1.2.5"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.11"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}