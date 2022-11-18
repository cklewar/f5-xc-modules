terraform {
  required_version = ">= 1.3.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version =  "= 0.11.16"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.40.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}