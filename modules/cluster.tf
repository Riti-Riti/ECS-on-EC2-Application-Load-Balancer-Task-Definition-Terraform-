# ---------------- ECS CLUSTER ----------------

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.env}-${var.cluster_name}"
}
