# ---------------- ECS SERVICES ----------------

resource "aws_ecs_service" "main" {
  name                = var.ecs_service_name
  cluster             = aws_ecs_cluster.this.id
  task_definition     = aws_ecs_task_definition.this.arn
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  health_check_grace_period_seconds = 0

  depends_on = [
    aws_ecs_cluster_capacity_providers.this,
    aws_lb_listener.https
  ]
}

resource "aws_ecs_service" "node_exporter" {
  count               = var.enable_node_exporter ? 1 : 0
  name                = "${var.project_name}-${var.env}-node-exporter"
  cluster             = aws_ecs_cluster.this.id
  task_definition     = var.node_exporter_task_def_arn
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  health_check_grace_period_seconds = 0
}
