#
# ECS cluster
#

resource "aws_ecs_cluster" "cluster" {
  name = var.CLUSTER_NAME
}

data "template_file" "ecs_init" {
  template = file("${path.module}/templates/ecs_init.tpl")
  vars = {
    CLUSTER_NAME = var.CLUSTER_NAME
  }
}

#
# launchconfig
#
resource "aws_launch_configuration" "launch_config" {
  name_prefix          = "ecs-${var.CLUSTER_NAME}-launchconfig"
  image_id             = "ami-098616968d61e549e"
  instance_type        = var.INSTANCE_TYPE
  key_name             = var.SSH_KEY_NAME
  iam_instance_profile = aws_iam_instance_profile.cluster-ec2-role.id
  security_groups      = [aws_security_group.cluster.id]
  user_data            = data.template_file.ecs_init.rendered
  lifecycle {
    create_before_destroy = true
  }
}

#
# autoscaling
# TODO: add autoscaling policy
resource "aws_autoscaling_group" "asg" {
  name                 = "ecs-${var.CLUSTER_NAME}-autoscaling"
  vpc_zone_identifier  = var.VPC_SUBNETS
  launch_configuration = aws_launch_configuration.launch_config.name
  termination_policies = split(",", var.ECS_TERMINATION_POLICIES)
  min_size             = var.ECS_MINSIZE
  max_size             = var.ECS_MAXSIZE
  desired_capacity     = var.ECS_DESIRED_CAPACITY

  tag {
    key                 = "Name"
    value               = "${var.CLUSTER_NAME}-ecs"
    propagate_at_launch = true
  }
}

