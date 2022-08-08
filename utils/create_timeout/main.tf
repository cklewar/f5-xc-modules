resource "time_sleep" "sleep" {
  depends_on      = [var.dependsOn]
  create_duration = var.timeout
}

resource "null_resource" "next" {
  depends_on = [time_sleep.sleep]
}