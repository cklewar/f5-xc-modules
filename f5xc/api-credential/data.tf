/*data "local_file" "response" {
  # depends_on = [null_resource.apply_credential]
  # count      = fileexists(null_resource.apply_credential.triggers.filename) == true ? 1 : 0
  filename   = "${path.module}/_out/response.json"
}*/

/*data "http" "credential" {
  count = fileexists(null_resource.apply_credential.triggers.filename) == true ? 1 : 0
  url   = format("%s/%s/%s", var.f5xc_api_url, local.credential_get_uri, jsondecode(data.local_file.response.*.content[0]).name)

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}*/