variable "project_name" { type = string }
variable "env"          { type = string }
variable "aws_region"   { type = string }

variable "service_name" {
  description = "Short name for the application/service, used to build resource names"
  type        = string
}

variable "cluster_name"        { type = string }
variable "ecs_service_name"    { type = string }
variable "task_family"         { type = string }
variable "key_pair_name"       { type = string }

variable "vpc_id"                 { type = string }
variable "subnets"                { type = list(string) }
variable "public_subnets_for_alb" { type = list(string) }

variable "ecs_security_group_name" { type = string }
variable "alb_security_group_name" { type = string }
variable "ssh_source_security_group_id" {
  description = "Security group ID allowed to SSH (port 22) into the ECS instances"
  type        = string
}

variable "alb_logs_bucket_name" {
  description = "Globally-unique S3 bucket name for ALB access logs"
  type        = string
}

variable "ecr_image"           { type = string }
variable "ecs_ami_ssm_param"   { type = string }
variable "instance_type"       { type = string }

variable "asg_min_size"         { type = number }
variable "asg_max_size"         { type = number }
variable "asg_desired_capacity" { type = number }

variable "enable_node_exporter" {
  description = "Whether to deploy the companion Node Exporter daemon service"
  type        = bool
  default     = false
}

variable "node_exporter_task_def_arn" {
  description = "Existing task definition ARN for Node Exporter (required if enable_node_exporter is true)"
  type        = string
  default     = ""
}

variable "owner_name"            { type = string }
variable "cost_center"           { type = string }
variable "application"           { type = string }
variable "created_by"            { type = string }
variable "billing_code"          { type = string }
variable "department"            { type = string }
variable "additional_tags_key"   { type = string }
variable "additional_tags_value" { type = string }

variable "elb_deletion_protection" { type = bool }
variable "certificate_arn"         { type = string }
