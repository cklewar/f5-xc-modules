provider "restapi" {
  uri                  = "${var.f5xc_api_schema}://${var.f5xc_api_url}/${format(var.f5xc_sms_base_uri, var.f5xc_namespace)}"
  alias                = "f5xc"
  debug                = var.restapi_debug
  write_returns_object = var.restapi_write_returns_object

  headers = {
    X-Auth-Token = var.f5xc_api_token
    Content-Type = "application/json"
  }

  create_method  = "CREATE"
  update_method  = "UPDATE"
  destroy_method = "DELETE"
}