resource "aws_iam_service_linked_role" "elasticloadbalancing" {
  provider         = aws.region
  aws_service_name = "elasticloadbalancing.amazonaws.com"
}
resource "aws_lb" "application-lb" {
  provider           = aws.region
  name               = "Rearc-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "Rearc-LB"
  }
}

resource "aws_lb_target_group" "rearc-lb-tg" {
  provider    = aws.region
  name        = "rearc-lb-tg"
  port        = var.rearc-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.rearc-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "rearc-target-group"
  }
}

resource "aws_lb_listener" "rearc-listener-http" {
  provider          = aws.region
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#Listener for HTTPS
resource "aws_lb_listener" "rearc-listener-https" {
  provider          = aws.region
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.rearc-lb-https.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rearc-lb-tg.arn
  }
}


resource "aws_lb_target_group_attachment" "EC2instance-attach" {
  provider         = aws.region
  target_group_arn = aws_lb_target_group.rearc-lb-tg.arn
  target_id        = aws_instance.EC2instance.id
  port             = var.rearc-port
}
