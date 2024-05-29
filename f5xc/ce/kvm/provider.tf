provider "volterra" {
  api_p12_file = "performance.staging.api-creds.p12"
  url          = "https://performance.staging.volterra.us/api"
}

provider "libvirt" {
  uri   = "qemu:///system"
}
