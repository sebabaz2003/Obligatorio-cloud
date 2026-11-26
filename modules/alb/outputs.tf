output "alb_dns_name" {
  description = "Direccion DNS publica del balanceador"
  value       = aws_lb.app.dns_name
}

output "target_group_arn" {
  description = "ARN del Target Group de aplicacion"
  value       = aws_lb_target_group.app.arn
}

