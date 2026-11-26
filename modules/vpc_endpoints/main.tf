

# Security Group para el endpoint de Secrets Manager
resource "aws_security_group" "secrets_endpoint" {
  name        = "${var.project_name}-sg-vpce-secrets"
  description = "Firewall del endpoint privado de Secrets Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-vpce-secrets"
  }
}

# Permitir conexiones HTTPS desde las EC2
resource "aws_vpc_security_group_ingress_rule" "secrets_https" {
  security_group_id = aws_security_group.secrets_endpoint.id

  referenced_security_group_id = var.app_security_group_id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# Endpoint privado para Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = var.app_subnet_ids

  security_group_ids = [
    aws_security_group.secrets_endpoint.id
  ]

  depends_on = [
    aws_vpc_security_group_ingress_rule.secrets_https
  ]

  tags = {
    Name = "${var.project_name}-vpce-secretsmanager"
  }
}


# Security Group para Systems Manager
resource "aws_security_group" "ssm_endpoint" {
  name        = "${var.project_name}-sg-vpce-ssm"
  description = "Firewall de los endpoints SSM"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-vpce-ssm"
  }
}

# Permitir HTTPS desde nuestras EC2
resource "aws_vpc_security_group_ingress_rule" "ssm_https" {
  security_group_id = aws_security_group.ssm_endpoint.id

  referenced_security_group_id = var.app_security_group_id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# Endpoints privados para Systems Manager
resource "aws_vpc_endpoint" "ssm" {
  for_each = toset(["ssm", "ssmmessages"])

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = var.app_subnet_ids

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  depends_on = [
    aws_vpc_security_group_ingress_rule.ssm_https
  ]

  tags = {
    Name = "${var.project_name}-vpce-${each.value}"
  }
}


# Security Group para el endpoint de CloudWatch Logs
resource "aws_security_group" "logs_endpoint" {
  name        = "${var.project_name}-sg-vpce-logs"
  description = "Firewall del endpoint privado de CloudWatch Logs"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-vpce-logs"
  }
}

# Permitir HTTPS desde las EC2 de la aplicacion
resource "aws_vpc_security_group_ingress_rule" "logs_https" {
  security_group_id = aws_security_group.logs_endpoint.id

  referenced_security_group_id = var.app_security_group_id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# Endpoint privado para CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = var.app_subnet_ids

  security_group_ids = [
    aws_security_group.logs_endpoint.id
  ]

  depends_on = [
    aws_vpc_security_group_ingress_rule.logs_https
  ]

  tags = {
    Name = "${var.project_name}-vpce-logs"
  }
}
