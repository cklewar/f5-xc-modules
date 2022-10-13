terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
