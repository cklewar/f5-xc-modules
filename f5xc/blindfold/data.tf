data "http" "policy_document" {
  depends_on = [null_resource.action_secret_policy_rule, null_resource.action_secret_policys]
  url        = format("%s/%s", var.f5xc_api_url, local.f5xc_secret_management_secret_policy_rules_get_uri)

  request_headers = {
    Authorization           = format("APIToken %s", var.f5xc_api_token)
    Accept                  = "application/json"
    x-volterra-apigw-tenant = var.f5xc_namespace
  }
}

data "http" "public_key" {
  depends_on = [null_resource.action_secret_policy_rule, null_resource.action_secret_policys]
  url        = format("%s/%s", var.f5xc_api_url, var.f5xc_secret_management_public_key_get_uri)

  request_headers = {
    Authorization           = format("APIToken %s", var.f5xc_api_token)
    Accept                  = "application/json"
    x-volterra-apigw-tenant = var.f5xc_namespace
  }
}