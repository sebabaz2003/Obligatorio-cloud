
# Grupo de subredes privadas para RDS
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnets"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnets"
  }
}

# Base de datos PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = "appadmin"

  manage_master_user_password = true

  multi_az = var.multi_az

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.db_security_group_id
  ]

  publicly_accessible = false

  backup_retention_period = 7

  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
