data "local_file" "state" {
  depends_on = [null_resource.apply_credential]
  # count      = fileexists(null_resource.apply_credential.triggers.filename) == true ? 1 : 0
  filename   = "${path.module}/_out/state.json"
}

data "http" "credential" {
  # count = fileexists(null_resource.apply_credential.triggers.filename) == true ? 1 : 0
  depends_on = [null_resource.apply_credential, data.local_file.state]
  url   = "${var.f5xc_api_url}/${local.credential_get_uri}/${jsondecode(data.local_file.state.content[0]).name}"

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}