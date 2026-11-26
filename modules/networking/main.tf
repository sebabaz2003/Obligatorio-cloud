
# Zonas de disponibilidad disponibles
data "aws_availability_zones" "available" {
  state = "available"
}

# Configuracion de las seis subredes
locals {
  subnets = {
    public_az1 = {
      cidr     = var.subnet_cidrs.public_az1
      az_index = 0
      tier     = "public"
    }
    public_az2 = {
      cidr     = var.subnet_cidrs.public_az2
      az_index = 1
      tier     = "public"
    }
    app_az1 = {
      cidr     = var.subnet_cidrs.app_az1
      az_index = 0
      tier     = "app"
    }
    app_az2 = {
      cidr     = var.subnet_cidrs.app_az2
      az_index = 1
      tier     = "app"
    }
    db_az1 = {
      cidr     = var.subnet_cidrs.db_az1
      az_index = 0
      tier     = "db"
    }
    db_az2 = {
      cidr     = var.subnet_cidrs.db_az2
      az_index = 1
      tier     = "db"
    }
  }
}

# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Creacion de las seis subredes
resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${each.key}"
    Tier = each.value.tier
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tabla de rutas publica
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

# Asociar ambas subredes publicas
resource "aws_route_table_association" "public" {
  for_each = toset(["public_az1", "public_az2"])

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

# Tablas de rutas privadas de aplicacion
resource "aws_route_table" "app" {
  for_each = toset(["az1", "az2"])

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-rt-app-${each.key}"
  }
}

resource "aws_route_table_association" "app" {
  for_each = toset(["az1", "az2"])

  subnet_id      = aws_subnet.subnets["app_${each.key}"].id
  route_table_id = aws_route_table.app[each.key].id
}

# Tablas de rutas privadas de base de datos
resource "aws_route_table" "db" {
  for_each = toset(["az1", "az2"])

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-rt-db-${each.key}"
  }
}

resource "aws_route_table_association" "db" {
  for_each = toset(["az1", "az2"])

  subnet_id      = aws_subnet.subnets["db_${each.key}"].id
  route_table_id = aws_route_table.db[each.key].id
}


# Obtener la region AWS actual
data "aws_region" "current" {}

# Permitir acceso privado a S3 desde las subredes de aplicacion
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    for rt in aws_route_table.app : rt.id
  ]

  tags = {
    Name = "${var.project_name}-vpce-s3"
  }
}

