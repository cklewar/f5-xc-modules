terraform {
  required_version = ">= 1.2.7"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.12"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"

  }
}