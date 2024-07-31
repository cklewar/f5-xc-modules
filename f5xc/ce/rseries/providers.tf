provider "restapi" {
  uri                  = "${var.f5os_api_schema}://${var.f5os_api_address}:${var.f5os_api_port}/${var.f5os_api_base_uri}"
  alias                = "f5os"
  debug                = var.restapi_debug
  username             = var.f5os_api_username
  password             = var.f5os_api_password
  write_returns_object = var.restapi_write_returns_object

  headers = {
    Accept       = "application/yang-data+json"
    Content-Type = "application/yang-data+json"
  }

  create_method  = "CREATE"
  update_method  = "UPDATE"
  destroy_method = "DELETE"
}