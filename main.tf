

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name

  db_subnet_ids = module.networking.private_db_subnet_ids

  db_security_group_id = module.security.db_sg_id

  instance_class    = var.db_instance_class
  multi_az          = var.db_multi_az
  db_name           = var.db_name
  allocated_storage = var.db_allocated_storage
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name

  war_path = "${path.root}/artifacts/catalogo-checkout-0.0.1-SNAPSHOT.war"
}

module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  project_name = var.project_name
  aws_region   = var.aws_region

  vpc_id                = module.networking.vpc_id
  app_subnet_ids        = module.networking.private_app_subnet_ids
  app_security_group_id = module.security.app_sg_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name

  aws_region = var.aws_region

  app_security_group_id = module.security.app_sg_id

  war_bucket_name = module.s3.bucket_name
  war_object_key  = module.s3.war_key

  db_host       = module.rds.db_host
  db_port       = module.rds.db_port
  db_name       = module.rds.db_name
  db_secret_arn = module.rds.db_secret_arn
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name

  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.security.alb_sg_id
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name = var.project_name

  private_app_subnet_ids = module.networking.private_app_subnet_ids

  launch_template_id = module.ec2.launch_template_id

  target_group_arn = module.alb.target_group_arn

  launch_template_version = module.ec2.launch_template_latest_version
}


