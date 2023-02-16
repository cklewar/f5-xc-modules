resource "aws_lb" "nlb" {
  tags                             = var.common_tags
  name                             = format("%s-nlb", var.f5xc_cluster_name)
  subnets                          = var.aws_nlb_subnets
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  timeouts {
    create = "35m"
    delete = "35m"
  }
}

resource "aws_lb_target_group" "controllers" {
  tags        = var.common_tags
  name        = format("%s-lb-ctl", var.f5xc_cluster_name)
  vpc_id      = var.aws_vpc_id
  target_type = "instance"
  protocol    = "TCP"
  port        = 6443

  health_check {
    protocol            = "TCP"
    port                = 6443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}

resource "aws_lb_listener" "api_server" {
  tags              = var.common_tags
  port              = "6443"
  protocol          = "TCP"
  load_balancer_arn = aws_lb.nlb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers.arn
  }
}

