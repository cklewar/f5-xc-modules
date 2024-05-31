provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
}

provider "libvirt" {
  uri = var.qemu_uri
}
