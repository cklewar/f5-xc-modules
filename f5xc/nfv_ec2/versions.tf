terraform {
  required_version = ">= 1.1.9"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.32.0"
    }

    local = ">= 2.0"
    null  = ">= 3.0"
  }
}
