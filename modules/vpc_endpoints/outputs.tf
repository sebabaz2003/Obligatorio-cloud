
output "secretsmanager_endpoint_id" {
  description = "ID del endpoint privado de Secrets Manager"
  value       = aws_vpc_endpoint.secretsmanager.id
}

