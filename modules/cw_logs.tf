# ---------------- CLOUDWATCH LOGS ----------------

resource "aws_cloudwatch_log_group" "ecs_task" {
  name              = "/ecs/${var.project_name}-${var.env}-${var.service_name}"
  retention_in_days = 14
}
