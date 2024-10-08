variable "f5xc_api_p12_file" {
  type = string
}

provider "volterra" {
  url          = var.f5xc_api_url
  alias        = "default"
  api_p12_file = var.f5xc_api_p12_file
}

provider "restful" {
  alias         = "default"
  base_url      = var.f5xc_api_url
  update_method = "PUT"
  create_method = "POST"
  delete_method = "DELETE"

  client = {
    retry = {
      status_codes = [500, 502, 503, 504]
      count           = 3
      wait_in_sec     = 1
      max_wait_in_sec = 120
    }
  }

  security = {
    apikey = [
      {
        in   = "header"
        name = "Authorization"
        value = format("APIToken %s", var.f5xc_api_token)
      }
    ]
  }
}