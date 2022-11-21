resource "time_sleep" "sleep" {
  depends_on       = [var.depend_on]
  create_duration  = var.create_timeout
  destroy_duration = var.delete_timeout
}

resource "null_resource" "next" {
  depends_on = [time_sleep.sleep]
}