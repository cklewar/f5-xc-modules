output "nlb" {
  value = {
    nlb          = aws_lb.nlb
    listener     = aws_lb_listener.api_server
    target_group = aws_lb_target_group.controllers
  }
}