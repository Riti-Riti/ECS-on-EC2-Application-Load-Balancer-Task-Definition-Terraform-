# ---------------- AUTO SCALING ----------------

resource "aws_autoscaling_group" "this" {
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  tag {
    key                 = "Name"
    value               = "ECS - ${local.full_cluster_name}"
    propagate_at_launch = true
  }
}
