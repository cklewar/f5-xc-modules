output "bigip" {
  value = {
    auth_token = data.http.auth_token.response_body
    waf_policy = data.http.bigip_waf_policy.response_body
  }
}