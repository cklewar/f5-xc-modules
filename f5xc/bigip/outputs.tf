output "auth_token" {
  value = data.http.auth_token.response_body
}

output "bigip_waf_policy" {
  value = data.http.bigip_waf_policy.response_body
}