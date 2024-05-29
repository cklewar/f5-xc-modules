terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }

    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.32"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
