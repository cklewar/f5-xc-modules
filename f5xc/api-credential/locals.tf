locals {
  credential_get_uri = format(var.f5xc_credential_get_uri, var.f5xc_namespace)
  state_file         = "${path.module}/_out/${var.f5xc_api_credentials_name}/state.json"
  script_file        = abspath("${path.module}/scripts/script.py")
  venv_path          = abspath(path.module)
}


