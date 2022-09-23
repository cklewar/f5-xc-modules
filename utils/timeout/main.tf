resource "time_sleep" "sleep" {
  # count           = var.action == var.action_create ? 1 : 0
  depends_on       = [var.dependsOn]
  #create_duration  = var.action == var.action_create ? var.timeout : null
  #destroy_duration = var.action == var.action_destroy ? var.timeout : null
  create_duration  = var.timeout
  destroy_duration = var.timeout
}

resource "null_resource" "next" {
  # count      = var.action == var.action_create ? 1 : 0
  depends_on = [time_sleep.sleep]
}

/*resource "time_sleep" "sleep_destroy" {
  count            = var.action == var.action_destroy ? 1 : 0
  depends_on       = [var.dependsOn]
  destroy_duration = var.timeout
}

resource "null_resource" "next_destroy" {
  count      = var.action == var.action_create ? 1 : 0
  depends_on = [time_sleep.sleep_create]
}*/