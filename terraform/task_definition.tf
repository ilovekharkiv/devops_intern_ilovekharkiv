resource "aws_ecs_task_definition" "task_definition" {
  family                = "terraform-ecs-worker"
  network_mode          = "host"
  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "534279642551.dkr.ecr.eu-north-1.amazonaws.com/backend:latest"
      cpu       = 300
      memory    = 400

     portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    },
    {
      name      = "postgres"
      image     = "postgres:11"
      cpu       = 300
      memory    = 400

      environment = [
        {"name": "DB_USER","value": "dbuser"},
        {"name": "DB_PASSWORD","value": "dbpassword"},
        {"name": "DB_ENDPOINT","value": "dbpostgres"},
        {"name": "DB_NAME","value": "postgres"},
        {"name": "POSTGRES_HOST_AUTH_METHOD","value": "trust"}
      ]

      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
        }
      ]
    },
    {
      name      = "frontend"
      image     = "534279642551.dkr.ecr.eu-north-1.amazonaws.com/frontend:latest"
      cpu       = 300
      memory    = 128
      interactive = true

      dependsOn: [
          {
            "containerName": "backend",
            "condition": "START"
          },
          {
            "containerName": "postgres",
            "condition": "START"
          }

      ]

     portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}