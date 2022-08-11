resource "volterra_healthcheck" "healthcheck" {
  name      = var.f5xc_healthcheck_name
  namespace = var.f5xc_namespace

  dynamic "http_health_check" {
    for_each = var.f5xc_healthcheck_type == var.f5xc_f5xc_healthcheck_type_http ? [1] : [0]
    content {
      use_origin_server_name    = var.f5xc_healthcheck_use_origin_server_name
      path                      = var.f5xc_healthcheck_path
      use_http2                 = var.f5xc_healthcheck_use_http2
      request_headers_to_remove = length(var.f5xc_healthcheck_request_headers_to_remove) > 0 ? var.f5xc_healthcheck_request_headers_to_remove : null
      host_header               = var.f5xc_healthcheck_http_host_header != "" ? var.f5xc_healthcheck_http_host_header : null
      headers                   = length(var.f5xc_healthcheck_http_headers) > 0 ? var.f5xc_healthcheck_http_headers : null
    }
  }

  dynamic "tcp_health_check" {
    for_each = var.f5xc_healthcheck_type == var.f5xc_f5xc_healthcheck_type_tcp ? [1] : [0]
    content {
      expected_response = var.f5xc_healthcheck_expected_response != "" ? var.f5xc_healthcheck_expected_response : null
      send_payload      = var.f5xc_healthcheck_send_payload != "" ? var.f5xc_healthcheck_send_payload : null
    }
  }

  healthy_threshold   = var.f5xc_healthcheck_healthy_threshold
  interval            = var.f5xc_healthcheck_interval
  timeout             = var.f5xc_healthcheck_timeout
  unhealthy_threshold = var.f5xc_healthcheck_unhealthy_threshold
}
