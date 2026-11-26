variable "project_name" {
  type = string
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "launch_template_version" {
  description = "Version del Launch Template"
  type        = number
}

variable "cpu_target_value" {
  description = "Porcentaje objetivo de CPU para Auto Scaling"
  type        = number
  default     = 60
}