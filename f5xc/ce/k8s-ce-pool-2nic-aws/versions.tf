terraform {
  required_version = ">= 1.1.9"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.9"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.14.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}