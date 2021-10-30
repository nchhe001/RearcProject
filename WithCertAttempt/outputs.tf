output "EC2-IP" {
  value = aws_instance.EC2instance.public_ip
}

output "Load_Balancer_DNS_NAME" {
  value = aws_lb.application-lb.dns_name
}

output "WebURL" {
  value = aws_route53_record.rearc.fqdn
} 