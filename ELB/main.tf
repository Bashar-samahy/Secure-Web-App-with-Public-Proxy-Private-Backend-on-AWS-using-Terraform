resource "aws_lb" "public" {
  name               = "bashar-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.proxy_sg_id]
  subnets            = values(var.public_subnet_ids)

  tags = {
    Name = "bashar-public-alb"
  }
}

resource "aws_lb_target_group" "proxy" {
  name     = "bashar-proxy-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "proxy" {
  count            = length(var.proxy_instances)
  target_group_arn = aws_lb_target_group.proxy.arn
  target_id        = var.proxy_instances[count.index]
  port             = 80
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy.arn
  }
}

resource "aws_lb" "internal" {
  name               = "bashar-app-internal-alb"  # Changed from "internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.backend_sg_id]
  subnets            = values(var.private_subnet_ids)

  tags = {
    Name = "internal-alb"
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "bashar-backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "backend" {
  count            = length(var.backend_instances)
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = var.backend_instances[count.index]
  port             = 80
}

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}