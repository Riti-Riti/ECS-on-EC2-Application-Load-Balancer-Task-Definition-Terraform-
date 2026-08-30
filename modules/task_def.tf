# ---------------- TASK DEFINITION ----------------

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  cpu                      = "1024"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.task.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.service_name}-container"
      image     = var.ecr_image
      essential = true
      memory    = 1024
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_task.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      ulimits = [
        {
          name      = "nofile"
          softLimit = 99999
          hardLimit = 99999
        }
      ]
      startTimeout = 60
      stopTimeout  = 60
    }
  ])

  tags = {
    "Cost Center"  = var.cost_center
    "Billing Code" = var.billing_code
    "Created by"   = var.created_by
    "Owner Name"   = var.owner_name
    "Department"   = var.department
    Project        = var.project_name
    Env            = var.env
  }

  depends_on = [aws_cloudwatch_log_group.ecs_task]
}
