terraform {
  required_version = ">= 1.2.4"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
