# ---------------- S3 (ALB LOGS) ----------------

resource "aws_s3_bucket" "alb_logs" {
  bucket = var.alb_logs_bucket_name
}

data "aws_iam_policy_document" "alb_logs" {
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject"]

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    resources = ["${aws_s3_bucket.alb_logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = data.aws_iam_policy_document.alb_logs.json
}
