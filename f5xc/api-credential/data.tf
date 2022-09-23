data "local_file" "response" {
  filename = null_resource.apply_credential.triggers.filename
}

data "http" "credential" {
  url = format("%s/%s/%s", var.f5xc_api_url, local.credential_get_uri, jsondecode(data.local_file.response.content).name)

  request_headers = {
    Content-Type = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}