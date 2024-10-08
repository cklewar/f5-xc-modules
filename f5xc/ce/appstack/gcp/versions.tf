terraform {
  required_version = ">= 1.7.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.37"
    }

   google = {
      source  = "hashicorp/google"
      version = ">= 4.48.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}