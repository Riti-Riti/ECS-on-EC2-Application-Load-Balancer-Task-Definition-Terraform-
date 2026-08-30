variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  description = "Short project/team identifier, used as a prefix on resource names"
  type        = string
  default     = "myproject"
}

variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "service_name" {
  description = "Short name for the application/service, used to build resource names"
  type        = string
  default     = "app"
}

variable "cluster_name" {
  type    = string
  default = "ecs-cluster"
}

variable "ecs_service_name" {
  type    = string
  default = "app-service"
}

variable "task_family" {
  type    = string
  default = "app-task"
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair for SSH access to the ECS instances"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  description = "Subnets for ECS EC2 instances (ASG)"
  type        = list(string)
}

variable "public_subnets_for_alb" {
  description = "Public subnets for the ALB"
  type        = list(string)
}

variable "ecs_security_group_name" {
  type    = string
  default = "app-ecs-sg"
}

variable "alb_security_group_name" {
  type    = string
  default = "app-alb-sg"
}

variable "ssh_source_security_group_id" {
  description = "Security group ID allowed to SSH (port 22) into the ECS instances (e.g. a bastion/jump host SG)"
  type        = string
}

variable "alb_logs_bucket_name" {
  description = "Globally-unique S3 bucket name for ALB access logs"
  type        = string
}

variable "ecr_image" {
  type        = string
  description = "ECR image URI for the application container"
  default     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
}

variable "ecs_ami_ssm_param" {
  description = "SSM parameter path for the ECS-optimized AMI"
  type        = string
  default     = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 4
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "enable_node_exporter" {
  description = "Whether to deploy a companion Node Exporter daemon service for metrics"
  type        = bool
  default     = false
}

variable "node_exporter_task_def_arn" {
  description = "Existing task definition ARN for Node Exporter (required if enable_node_exporter is true)"
  type        = string
  default     = ""
}

variable "owner_name" {
  type    = string
  default = "Platform Team"
}

variable "cost_center" {
  type    = string
  default = "Engineering"
}

variable "application" {
  type    = string
  default = "MyApp"
}

variable "created_by" {
  type    = string
  default = "you@example.com"
}

variable "billing_code" {
  type    = string
  default = "Engineering"
}

variable "department" {
  type    = string
  default = "Engineering"
}

variable "additional_tags_key" {
  description = "Optional extra tag key (e.g. for a migration-tracking or governance tag)"
  type        = string
  default     = ""
}

variable "additional_tags_value" {
  description = "Optional extra tag value, paired with additional_tags_key"
  type        = string
  default     = ""
}

variable "elb_deletion_protection" {
  description = "Whether to enable deletion_protection for the ALB"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the ALB HTTPS listener"
  type        = string
}
