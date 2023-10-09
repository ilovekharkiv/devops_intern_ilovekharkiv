resource "aws_alb_listener" "default" {

  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = aws_alb_target_group.frontend.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "frontend" {

  listener_arn = aws_alb_listener.default.arn
  priority    = 110

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
}

}

resource "aws_alb_listener_rule" "backend" {

  listener_arn = aws_alb_listener.default.arn
  priority    = 120

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["8000/api/*"]
    }
}
}