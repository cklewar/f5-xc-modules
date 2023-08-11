output "get_response" {
  value = data.http.get.response_body
}

output "data" {
  value = data.local_file.data.content
}

output "put_response" {
  value = data.http.update.response_body
}