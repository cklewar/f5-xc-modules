resource "time_sleep" "sleep_create" {
  count           = var.action == var.action_create ? 1 : 0
  depends_on      = [var.dependsOn]
  create_duration = var.timeout
}

resource "null_resource" "next_create" {
  count      = var.action == var.action_create ? 1 : 0
  depends_on = [time_sleep.sleep_create]
}

resource "time_sleep" "sleep_destroy" {
  count            = var.action == var.action_destroy ? 1 : 0
  depends_on       = [var.dependsOn]
  destroy_duration = var.timeout
}

resource "null_resource" "next_destroy" {
  count      = var.action == var.action_create ? 1 : 0
  depends_on = [time_sleep.sleep_create]
}