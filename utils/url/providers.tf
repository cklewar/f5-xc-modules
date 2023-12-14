provider "volterra" {
  url          = "${var.schema}${var.f5xc_url}/api"
  alias        = "default"
  timeout      = "30s"
  api_p12_file = var.f5xc_api_p12_file
}