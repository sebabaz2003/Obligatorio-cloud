
output "secretsmanager_endpoint_id" {
  description = "ID del endpoint privado de Secrets Manager"
  value       = aws_vpc_endpoint.secretsmanager.id
}

output "ssm_endpoint_ids" {
  value = {
    for name, endpoint in aws_vpc_endpoint.ssm :
    name => endpoint.id
  }
}

