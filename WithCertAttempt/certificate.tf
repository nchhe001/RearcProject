#Creates ACM certificate and requests validation via DNS(Route53)
resource "aws_acm_certificate" "rearc-lb-https" {
  provider          = aws.region
  domain_name       = join(".", ["rearc", data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "Rearc-ACM"
  }
}

#Certificate validation via Route53
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region
  certificate_arn         = aws_acm_certificate.rearc-lb-https.arn
  for_each                = aws_route53_record.cert_validation
  validation_record_fqdns = [aws_route53_record.cert_validation[each.key].fqdn]
}

####ACM CONFIG END

resource "aws_lb_listener" "rearc-listener" {
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
