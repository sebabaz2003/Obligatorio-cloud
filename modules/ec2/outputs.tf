output "launch_template_id" {
  description = "ID del Launch Template de aplicacion"
  value       = aws_launch_template.app.id
}

output "launch_template_latest_version" {
  description = "Ultima version del Launch Template"
  value       = aws_launch_template.app.latest_version
}

