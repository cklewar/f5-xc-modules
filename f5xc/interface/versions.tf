terraform {
  required_version = ">= 1.3.0"
  # experiments      = [module_variable_optional_attrs]

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version =  "= 0.11.16"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}