# ECS on EC2 — Application Load Balancer + Task Definition (Terraform)

A reusable Terraform template for running a containerized service on **Amazon ECS
with self-managed EC2 instances**, fronted by an **Application Load Balancer (ALB)**
and **Target Group (TG)** for external access, with logs and metrics wired up out
of the box.

Use this as a starting point for any service that needs:

- A cluster of EC2 instances managed by an Auto Scaling Group + ECS Capacity
  Provider (scales automatically as tasks are scheduled)
- Your application running as a **replica on every instance in the cluster** —
  the ECS service uses `DAEMON` scheduling, so one copy of the task runs on each
  EC2 instance (similar in spirit to a Kubernetes DaemonSet), rather than a fixed
  task count you manage yourself
- An **ALB + Target Group** exposing that service to the internet (or internally)
  over HTTPS, with health checks and access logging to S3
- Centralized logs in CloudWatch
- An optional companion Node Exporter service for infrastructure metrics

## Architecture

- **ECS Cluster** — EC2 launch type, backed by a managed Capacity Provider.
- **Launch Template + Auto Scaling Group** — provisions ECS-optimized Amazon
  Linux instances (AMI resolved via SSM) that automatically register into the
  cluster.
- **Task Definition** — single container, host networking, logs shipped to
  CloudWatch.
- **ECS Service** — `DAEMON` scheduling strategy, so the task runs as a replica
  on every instance in the cluster; scales in/out automatically as the ASG does.
- **ALB + Target Group** — internet-facing, HTTPS listener forwarding to the
  service's port, with a configurable health-check path and access logs
  delivered to S3.
- **Security Groups** — ALB open on 80/443 to the internet; ECS instances only
  reachable from the ALB (plus SSH from a designated bastion/jump SG and an
  internal VPC CIDR).
- **IAM** — separate roles for ECS task execution and for the EC2 instances
  (SSM + ECS instance role policies).
- **(Optional) Node Exporter** — a second `DAEMON` service for exposing host
  metrics, disabled by default.

## Repository layout

```
.
├── main.tf                     # Provider config + single call into ./modules
├── variables.tf                 # Root-level variable declarations
├── terraform.tfvars.example     # Example values — copy to terraform.tfvars and edit
└── modules/
    ├── variables.tf              # Module input variables
    ├── outputs.tf                # Module outputs (ALB DNS, ARNs, etc.)
    ├── sg.tf                     # ECS SG + ALB SG
    ├── iam.tf                    # Task role, EC2 role, instance profile
    ├── cluster.tf                # ECS cluster
    ├── lt.tf                     # Launch template + SSM AMI lookup
    ├── asg.tf                    # Auto Scaling Group
    ├── cp.tf                     # ECS capacity provider + cluster association
    ├── cw_logs.tf                # CloudWatch log group
    ├── task_def.tf                # ECS task definition
    ├── ecs_service.tf             # App service + optional node-exporter service
    ├── s3.tf                      # ALB access-logs bucket + policy
    └── alb.tf                     # ALB, target group, HTTPS listener
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- AWS credentials with permissions to manage ECS, EC2, ASG, ALB, IAM, S3, and
  CloudWatch Logs (via environment variables, `~/.aws/credentials`, or an
  assumed role)
- An existing VPC with:
  - At least one subnet for the ECS instances
  - At least two public subnets (in different AZs) for the ALB
- An ACM certificate issued in the same region as the ALB, for the HTTPS
  listener
- An existing EC2 key pair (referenced by name) for SSH access to the instances
- An existing security group to allow as the SSH source (e.g. a bastion/jump
  host SG)
- A globally-unique S3 bucket name for ALB access logs

## Getting started

```bash
git clone <this-repo-url>
cd <this-repo>

cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your VPC, subnets, certificate, image, etc.

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

To tear everything down:

```bash
terraform destroy
```

> **Note:** the ALB has `enable_deletion_protection` set via
> `elb_deletion_protection` (default `true`). Set it to `false` in
> `terraform.tfvars` before running `destroy`, or the destroy will fail on the
> load balancer.

## Required variables

These have no default and must be set in `terraform.tfvars`:

| Variable | Description |
|---|---|
| `vpc_id` | VPC to deploy into |
| `subnets` | Subnet IDs for the ECS Auto Scaling Group |
| `public_subnets_for_alb` | Public subnet IDs for the ALB (2+ AZs) |
| `key_pair_name` | Existing EC2 key pair name |
| `ssh_source_security_group_id` | Security group allowed to SSH into the ECS instances |
| `alb_logs_bucket_name` | Globally-unique S3 bucket name for ALB access logs |
| `certificate_arn` | ACM certificate ARN for the HTTPS listener |

Everything else in `variables.tf` has a generic default you can override —
in particular you'll usually want to set your own `project_name`,
`service_name`, `env`, and `ecr_image`.

## Outputs

After `apply`, Terraform prints:

- `alb_dns_name` — DNS name of the load balancer
- `ecs_cluster_name` — name of the ECS cluster
- `ecs_service_name` — name of the ECS service
- `task_definition_arn` — ARN of the registered task definition

## State management

This repo does not commit `terraform.tfstate` or `.terraform/`. For anything
beyond local experimentation, configure a remote backend (S3 + DynamoDB lock
table, Terraform Cloud, etc.) in `main.tf` before running `terraform init`.

## Notes / things to double-check before production use

- The S3 bucket policy for ALB access logs uses the
  `logdelivery.elasticloadbalancing.amazonaws.com` service principal. Some AWS
  regions/older accounts require the regional ELB account ID as the principal
  instead — verify against the
  [current AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html)
  for your region.
- `ecs_ami_ssm_param` defaults to Amazon Linux 2023; change it if you need a
  different ECS-optimized AMI family.
- `DAEMON` scheduling means the task count follows your instance count — if
  you need a fixed number of replicas instead, switch the service's
  `scheduling_strategy` to `REPLICA` and set a `desired_count`.
- The optional Node Exporter service (`enable_node_exporter`) expects an
  **existing** task definition ARN; it does not create one for you.

## .gitignore

Recommended, if not already present:

```
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log
.terraform.lock.hcl
terraform.tfvars
```
