resource "aws_ecs_service" "worker" {
  name            = "terraform-ecs-worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  health_check_grace_period_seconds = 700000 # the only way to pass the ALB health check for backend. Postpone health call, currently 194 hours
  
  load_balancer {
    target_group_arn = aws_alb_target_group.frontend.arn
    container_name = "frontend"
    container_port = 80
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.backend.arn
    container_name = "backend"
    container_port = 8000
  }
}

