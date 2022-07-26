terraform {
  required_version = ">= 1.2.4"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.18.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}
