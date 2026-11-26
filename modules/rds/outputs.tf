
output "db_host" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "db_secret_arn" {
  value = aws_db_instance.postgres.master_user_secret[0].secret_arn
}
