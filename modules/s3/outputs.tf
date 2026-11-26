output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = local.bucket_name
}

output "war_key" {
  description = "Ruta del WAR dentro del bucket"
  value       = aws_s3_object.war.key
}

output "war_arn" {
  description = "ARN del objeto WAR"
  value       = aws_s3_object.war.arn
}