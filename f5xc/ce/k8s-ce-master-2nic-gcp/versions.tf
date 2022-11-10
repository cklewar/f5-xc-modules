terraform {
  required_version = ">= 1.1.9"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version =  "= 0.11.16"
    }

    google = {
      source  = "hashicorp/google"
      version = ">=4.22.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}