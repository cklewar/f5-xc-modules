resource "volterra_namespace" "namespace" {
  name = var.f5xc_namespace_name
}

resource "time_sleep" "wait_n_seconds" {
  count           = var.f5xc_namespace_create_timeout == "0s" ? 1 : 0
  depends_on      = [volterra_namespace.namespace]
  create_duration = var.f5xc_namespace_create_timeout
}

resource "null_resource" "next" {
  count      = var.f5xc_namespace_create_timeout == "0s" ? 1 : 0
  depends_on = [time_sleep.wait_n_seconds]
}