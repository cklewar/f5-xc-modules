terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.3.1"
    }

    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.21"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"

  }
}
