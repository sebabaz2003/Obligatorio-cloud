
variable "aws_region" {
  description = "Region AWS del laboratorio"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "obligatorio-cloud"
}

variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "Bloques CIDR de las subredes"
  type = object({
    public_az1 = string
    public_az2 = string
    app_az1    = string
    app_az2    = string
    db_az1     = string
    db_az2     = string
  })
}

#RDS 
variable "db_instance_class" {
  description = "Tipo de instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  description = "Habilitar alta disponibilidad Multi-AZ"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "ecommerce_catalogo"
}

variable "db_allocated_storage" {
  description = "Almacenamiento en GiB"
  type        = number
  default     = 20
}

