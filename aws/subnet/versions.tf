terraform {
  required_version = ">= 1.2.5"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.25.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
