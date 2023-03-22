data "local_file" "state" {
  depends_on = [null_resource.apply_credential]
  # count      = fileexists(local.state_file) == true ? 1 : 0
  filename   = local.state_file
}

data "http" "credential" {
  depends_on = [null_resource.apply_credential]
  # count = fileexists(local.state_file) == true ? 1 : 0
  url   = "${var.f5xc_api_url}/${local.credential_get_uri}/${jsondecode(data.local_file.state.content).name}"

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}