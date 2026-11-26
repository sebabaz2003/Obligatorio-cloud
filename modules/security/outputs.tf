
output "alb_sg_id" {
  description = "Security Group del ALB"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security Group de las EC2"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security Group de RDS"
  value       = aws_security_group.db.id
}
