locals {
  f5xc_labels = merge({
    tf_vk8s_filter = var.f5xc_vk8s_name
  }, var.f5xc_labels)
}