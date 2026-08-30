output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "listener_arn" {
  value = aws_lb_listener.https.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.main.name
}

output "node_exporter_service_name" {
  value = var.enable_node_exporter ? aws_ecs_service.node_exporter[0].name : null
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_logs.id
}
