resource "aws_lb" "alb_us_east_1" {
  name               = "alb-us-east-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids_us_east_1

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg_us_east_1" {
  name     = "tg-us-east-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_us_east_1

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "listener_us_east_1" {
  load_balancer_arn = aws_lb.alb_us_east_1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_us_east_1.arn
  }
}

resource "aws_lb" "alb_us_west_2" {
  name               = "alb-us-west-2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids_us_west_2
  provider           = aws.us-west-2

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg_us_west_2" {
  name     = "tg-us-west-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_us_west_2
  provider = aws.us-west-2

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "listener_us_west_2" {
  load_balancer_arn = aws_lb.alb_us_west_2.arn
  port              = "80"
  protocol          = "HTTP"
  provider          = aws.us-west-2

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_us_west_2.arn
  }
}
