
# Obtener la AMI oficial de Amazon Linux 2023
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Plantilla para nuestros servidores de aplicacion
resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-app-"

  image_id      = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type

  # Script que se ejecutara cuando arranque cada EC2
  user_data = base64encode(templatefile(
    "${path.module}/user_data.sh.tftpl",
    {
      aws_region      = var.aws_region
      war_bucket_name = var.war_bucket_name
      war_object_key  = var.war_object_key

      db_host       = var.db_host
      db_port       = var.db_port
      db_name       = var.db_name
      db_secret_arn = var.db_secret_arn
    }
  ))

  # Rol IAM proporcionado por AWS Academy
  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  # Security Group de la aplicacion
  vpc_security_group_ids = [
    var.app_security_group_id
  ]

  # Exigir IMDSv2 para las credenciales temporales
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Etiquetas de las instancias creadas
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app"
    }
  }

  update_default_version = true
}

