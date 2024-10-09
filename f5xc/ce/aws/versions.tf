terraform {
  required_version = ">= 1.7.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.37"
    }

    restful = {
      source  = "magodo/restful"
      version = ">= 0.16.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.59.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}