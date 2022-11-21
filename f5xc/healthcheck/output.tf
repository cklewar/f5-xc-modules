output "healthcheck" {
  value = {
    "name"              = volterra_healthcheck.healthcheck.name
    "id"                = volterra_healthcheck.healthcheck.id
    "timeout"           = volterra_healthcheck.healthcheck.timeout
    "healthy_threshold" = volterra_healthcheck.healthcheck.healthy_threshold
    "interval"          = volterra_healthcheck.healthcheck.interval
  }
}