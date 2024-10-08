terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }

    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.37"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"

  }
}
