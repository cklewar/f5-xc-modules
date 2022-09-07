terraform {
  required_version = ">= 1.1.9"

  required_providers {

    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.12"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.18.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 2.2.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}