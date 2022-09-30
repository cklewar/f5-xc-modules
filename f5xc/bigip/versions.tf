terraform {
  required_version = ">= 1.3.0"

  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = ">= 1.15.2"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}