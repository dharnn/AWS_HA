output "alb_dns_name" {
  value = aws_lb.loadbalancer.dns_name
  description = "The DNS A Record of the Load Balancer"
}