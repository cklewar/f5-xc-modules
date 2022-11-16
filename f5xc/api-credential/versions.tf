terraform {
  required_version = ">= 1.3.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"

  }
}