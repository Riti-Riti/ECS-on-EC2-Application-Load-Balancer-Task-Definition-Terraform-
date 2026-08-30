aws_region   = "us-east-1"
project_name = "myproject"
env          = "prod"
service_name = "app"

cluster_name     = "ecs-cluster"
ecs_service_name = "app-service"
task_family      = "app-task"
key_pair_name    = "my-ec2-keypair"

# --- Required: no defaults, must match your account/VPC ---
vpc_id                        = "vpc-xxxxxxxxxxxxxxxxx"
subnets                       = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
public_subnets_for_alb        = ["subnet-aaaaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbbbbbb"]
ssh_source_security_group_id  = "sg-xxxxxxxxxxxxxxxxx"
alb_logs_bucket_name          = "myproject-prod-alb-logs" # must be globally unique
certificate_arn               = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

ecs_security_group_name = "app-ecs-sg"
alb_security_group_name = "app-alb-sg"

ecr_image         = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
ecs_ami_ssm_param = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
instance_type     = "t3.small"

asg_min_size         = 1
asg_max_size         = 4
asg_desired_capacity = 1

# Optional companion metrics service (disabled by default)
enable_node_exporter       = false
node_exporter_task_def_arn = ""

owner_name   = "Platform Team"
cost_center  = "Engineering"
application  = "MyApp"
created_by   = "you@example.com"
billing_code = "Engineering"
department   = "Engineering"

# Optional extra tag (leave both blank to skip)
additional_tags_key   = ""
additional_tags_value = ""

elb_deletion_protection = true
