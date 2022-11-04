output "blindfold" {
  value = {
    policy_document = jsondecode(data.http.policy_document.response_body)
    public_key      = jsondecode(data.http.public_key.response_body)
  }
}