resource "aws_lb" "mlflow_lb" {
  name               = "${var.app_name}-${var.env}-ecs-lb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  idle_timeout       = 60

  security_groups = [var.lb_security_group_id]
  subnets         = var.vpc_public_subnet_ids
}

resource "aws_lb_target_group" "mlflow_lb_target_grp" {
  name            = "${var.app_name}-${var.env}-ecslb-tgt-grp"
  port            = var.ecs_lb_listener_port
  protocol        = "HTTP"
  vpc_id          = var.vpc_id
  target_type     = "ip"
  ip_address_type = "ipv4"

  health_check {
    protocol = "HTTP"
    matcher  = "200-202"
    path     = "/ping"
  }
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.mlflow_lb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mlflow_lb_target_grp.arn
  }
}
