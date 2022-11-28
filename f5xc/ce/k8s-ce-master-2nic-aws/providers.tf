provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  token      = var.session_token
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  api_cert     = var.api_p12_file != "" ? "" : var.api_cert
  api_key      = var.api_p12_file != "" ? "" : var.api_key
  api_ca_cert  = var.api_ca_cert
  url          = var.api_url
}