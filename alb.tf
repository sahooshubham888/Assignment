resource "aws_lb" "internal" {
  name               = "my-internal-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0b2c395116ac4f14b,subnet-0e54ada37f64b1f2f"]
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "custom_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "internal_target_group" {
  name        = "internal-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = aws_vpc.custom_vpc.id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "internal_listener_rule" {
  listener_arn = aws_lb_listener.internal_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_target_group.arn
  }

  condition {
    host_header {
      values = ["*"]
    }
  }
}

output "alb_dns_name" {
  value = aws_lb.internal.dns_name
}
