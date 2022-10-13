terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.40.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}