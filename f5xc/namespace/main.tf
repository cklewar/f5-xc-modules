resource "volterra_namespace" "namespace" {
  name = var.f5xc_namespace_name
}

resource "time_sleep" "wait_n_seconds" {
  depends_on      = [volterra_namespace.namespace]
  create_duration = var.f5xc_namespace_create_timeout
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_n_seconds]
}