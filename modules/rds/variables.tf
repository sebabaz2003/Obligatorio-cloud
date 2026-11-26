
variable "project_name" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_security_group_id" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "db_name" {
  type = string
}

variable "allocated_storage" {
  type = number
}
