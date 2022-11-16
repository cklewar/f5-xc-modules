data "local_file" "response" {
  depends_on = [null_resource.apply_credential]
  count      = fileexists(null_resource.apply_credential.triggers.filename) ? 1 : 0
  filename   = null_resource.apply_credential.triggers.filename
}

data "http" "credential" {
  count = fileexists(null_resource.apply_credential.triggers.filename) ? 1 : 0
  # https://playground.staging.volterra.us/api/web/namespaces/system/api_credentials/f5xc-vk8s-credential-01-cwcjeirw
  url   = format("%s/%s/%s", var.f5xc_api_url, local.credential_get_uri, jsondecode(data.local_file.response.*.content[0]).name)
  # url = format("https://playground.staging.volterra.us/api/web/namespaces/system/api_credentials/%s", )

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}