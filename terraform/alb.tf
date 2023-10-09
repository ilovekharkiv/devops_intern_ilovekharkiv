resource "aws_alb" "default" {
  name            = "alb"
  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.pub_subnet1.id,
    aws_subnet.pub_subnet2.id,
  ]
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_alb.default.dns_name
}