output "blindfold" {
  value = {
    policy_document = data.http.policy_document.response_body["data"]
    public_key      = data.http.public_key.response_body["data"]
  }
}