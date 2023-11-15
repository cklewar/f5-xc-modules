output "service_policy" {
  value = volterra_service_policy.service_policy
}

output "all" {
  value = var.f5xc_service_policy
}

output "length" {
  value = length(var.f5xc_service_policy.allow_list)
}

output "loop" {
  value = {for k, v  in var.f5xc_service_policy.allow_list : k  => v}
}