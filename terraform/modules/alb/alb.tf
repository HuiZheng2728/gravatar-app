#
# ECS ALB
#
# alb main definition
resource "aws_alb" "alb" {
  name            = var.ALB_NAME
  internal        = var.INTERNAL
  security_groups = [aws_security_group.alb.id]
  subnets         = var.VPC_SUBNETS

  enable_deletion_protection = false
  tags            = var.TAGS
}

resource "aws_alb_listener" "alb-http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.DEFAULT_TARGET_ARN
    type             = "forward"
  }
}

