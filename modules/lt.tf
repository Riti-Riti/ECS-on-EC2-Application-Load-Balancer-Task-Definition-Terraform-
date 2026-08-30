# ---------------- LAUNCH TEMPLATE ----------------

data "aws_ssm_parameter" "ecs_ami" {
  name = var.ecs_ami_ssm_param
}

locals {
  full_cluster_name = "${var.project_name}-${var.env}-${var.cluster_name}"

  user_data = <<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${local.full_cluster_name} >> /etc/ecs/ecs.config;
  EOF
}

resource "aws_launch_template" "this" {
  name          = "${var.project_name}-${var.env}-ecs-launch-template"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.ecs.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ECS - ${local.full_cluster_name}"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "ECS - ${local.full_cluster_name}"
    }
  }

  user_data = base64encode(local.user_data)
}
