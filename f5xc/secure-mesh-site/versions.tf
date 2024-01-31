terraform {
  required_version = ">= 1.3.0"

  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.18.0"
    }
    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}