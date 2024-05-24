variable "f5xc_api_url" {
  type = string
}

variable "production_api_base" {
  type    = string
  default = ".console.ves.volterra.io/api"
  # https://playground.console.ves.volterra.io/api
}