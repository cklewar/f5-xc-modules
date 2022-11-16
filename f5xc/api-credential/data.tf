data "local_file" "response" {
  count    = fileexists(null_resource.apply_credential.triggers.filename) ? 1 : 0
  filename = null_resource.apply_credential.triggers.filename
}

data "http" "credential" {
  count    = fileexists(null_resource.apply_credential.triggers.filename) ? 1 : 0
  url = format("%s/%s/%s", var.f5xc_api_url, local.credential_get_uri, jsondecode(data.local_file.response.*.content).name)

  request_headers = {
    Content-Type = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}