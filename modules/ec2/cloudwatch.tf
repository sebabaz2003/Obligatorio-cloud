
# Logs de Tomcat
resource "aws_cloudwatch_log_group" "tomcat" {
  name              = "/${var.project_name}/tomcat"
  retention_in_days = 7
}

# Logs de accesos HTTP
resource "aws_cloudwatch_log_group" "tomcat_access" {
  name              = "/${var.project_name}/tomcat-access"
  retention_in_days = 7
}

# Logs de la aplicacion Java desde journald
resource "aws_cloudwatch_log_group" "application" {
  name              = "/${var.project_name}/application"
  retention_in_days = 7
}
