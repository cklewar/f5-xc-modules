output "blindfold" {
  value = {
    policy_document = data.http.policy_document.response_body
    public_key      = data.http.public_key
  }
}