

#NETWORKING
output "vpc_id" {
  description = "Identificador de la VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Subredes publicas"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Subredes privadas de aplicacion"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Subredes privadas de base de datos"
  value       = module.networking.private_db_subnet_ids
}


#SECURITY GROUPS
output "alb_security_group_id" {
  value = module.security.alb_sg_id
}

output "app_security_group_id" {
  value = module.security.app_sg_id
}

output "db_security_group_id" {
  value = module.security.db_sg_id
}

#RDS
output "db_host" {
  value = module.rds.db_host
}

output "db_port" {
  value = module.rds.db_port
}

output "db_name" {
  value = module.rds.db_name
}

output "db_secret_arn" {
  value = module.rds.db_secret_arn
}

#S3 .WAR
output "war_bucket_name" {
  value = module.s3.bucket_name
}

output "war_object_key" {
  value = module.s3.war_key
}

output "war_object_arn" {
  value = module.s3.war_arn
}

#vpc endpoint s3
output "s3_vpc_endpoint_id" {
  value = module.networking.s3_vpc_endpoint_id
}

output "secretsmanager_endpoint_id" {
  value = module.vpc_endpoints.secretsmanager_endpoint_id
}

#ec2
output "app_launch_template_id" {
  value = module.ec2.launch_template_id
}

