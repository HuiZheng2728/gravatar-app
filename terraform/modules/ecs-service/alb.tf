#
# target
#
resource "aws_alb_target_group" "ecs-service" {
  name = "${var.APPLICATION_NAME}-${substr(
    md5(
      format(
        "%s%s%s",
        var.APPLICATION_PORT,
        var.DEREGISTRATION_DELAY,
        var.HEALTHCHECK_MATCHER,
      ),
    ),
    0,
    12,
  )}"
  port                 = var.APPLICATION_PORT
  protocol             = "HTTP"
  vpc_id               = var.VPC_ID
  deregistration_delay = var.DEREGISTRATION_DELAY

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
    path                = "/health"
    interval            = 60
    matcher             = var.HEALTHCHECK_MATCHER
    timeout             = 30
  }
}

