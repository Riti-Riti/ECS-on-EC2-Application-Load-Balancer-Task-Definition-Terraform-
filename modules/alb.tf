# ---------------- ALB ----------------

resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.env}-${var.service_name}-alb"
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  internal           = false
  subnets            = var.public_subnets_for_alb
  security_groups    = [aws_security_group.alb.id]

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    enabled = true
  }

  enable_deletion_protection = var.elb_deletion_protection

  tags = merge(
    {
      Name           = "${var.project_name}-${var.env}-${var.service_name}-alb"
      Env            = var.env
      "Owner Name"   = var.owner_name
      Project        = var.project_name
      "Cost Center"  = var.cost_center
      Application    = var.application
      "Created by"   = var.created_by
      "Billing Code" = var.billing_code
      Department     = var.department
    },
    var.additional_tags_key != "" ? { (var.additional_tags_key) = var.additional_tags_value } : {}
  )

  depends_on = [aws_s3_bucket_policy.alb_logs]
}

resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-${var.env}-${var.service_name}-tg"
  target_type = "ip"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path    = "/healthcheck"
    matcher = "200-399"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
