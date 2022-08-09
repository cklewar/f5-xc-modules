output "vk8s" {
  value = {
    "name" = volterra_virtual_k8s.vk8s.name
    "id"   = volterra_virtual_k8s.vk8s.id
  }
}