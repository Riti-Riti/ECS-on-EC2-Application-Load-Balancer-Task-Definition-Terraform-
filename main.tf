terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ecs_app" {
  source = "./modules"

  aws_region   = var.aws_region
  project_name = var.project_name
  env          = var.env
  service_name = var.service_name

  cluster_name     = var.cluster_name
  ecs_service_name = var.ecs_service_name
  task_family      = var.task_family
  key_pair_name    = var.key_pair_name

  vpc_id                 = var.vpc_id
  subnets                = var.subnets
  public_subnets_for_alb = var.public_subnets_for_alb

  ecs_security_group_name      = var.ecs_security_group_name
  alb_security_group_name      = var.alb_security_group_name
  ssh_source_security_group_id = var.ssh_source_security_group_id

  alb_logs_bucket_name = var.alb_logs_bucket_name

  ecr_image         = var.ecr_image
  ecs_ami_ssm_param = var.ecs_ami_ssm_param
  instance_type     = var.instance_type

  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity

  enable_node_exporter       = var.enable_node_exporter
  node_exporter_task_def_arn = var.node_exporter_task_def_arn

  owner_name            = var.owner_name
  cost_center           = var.cost_center
  application           = var.application
  created_by            = var.created_by
  billing_code          = var.billing_code
  department            = var.department
  additional_tags_key   = var.additional_tags_key
  additional_tags_value = var.additional_tags_value

  elb_deletion_protection = var.elb_deletion_protection
  certificate_arn         = var.certificate_arn
}

output "alb_dns_name" {
  value = module.ecs_app.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs_app.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs_app.ecs_service_name
}

output "task_definition_arn" {
  value = module.ecs_app.task_definition_arn
}
