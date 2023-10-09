resource "aws_alb_target_group" "frontend" {
  
  health_check {
    path = "/"
  }

  name     = "frontend"
  port     = 80
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_alb_target_group" "backend" {
  
  health_check {
    path = "/health"
    unhealthy_threshold = 5
    interval = 60
  }

  name     = "backend"
  port     = 8000
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = aws_vpc.vpc.id
}