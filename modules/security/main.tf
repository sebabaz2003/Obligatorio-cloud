
# Security Group del Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-sg-alb"
  description = "Firewall del Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-alb"
  }
}

# Security Group de las EC2
resource "aws_security_group" "app" {
  name        = "${var.project_name}-sg-app"
  description = "Firewall de los servidores de aplicacion"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-app"
  }
}

# Security Group de PostgreSQL
resource "aws_security_group" "db" {
  name        = "${var.project_name}-sg-db"
  description = "Firewall de la base de datos"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-db"
  }
}

# Internet -> ALB, puerto 80
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

# ALB -> EC2, puerto 8080
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

# EC2 recibe trafico solamente desde ALB
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

# EC2 -> PostgreSQL, puerto 5432
resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.db.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

# EC2 puede utilizar HTTPS para servicios y descargas
resource "aws_vpc_security_group_egress_rule" "app_https" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

# PostgreSQL recibe conexiones solamente desde EC2
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id = aws_security_group.db.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
