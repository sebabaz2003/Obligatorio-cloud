variable "project_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_security_group_id" {
  type = string
}

variable "war_bucket_name" {
  type = string
}

variable "war_object_key" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_secret_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

