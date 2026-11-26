
variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidrs" {
  type = object({
    public_az1 = string
    public_az2 = string
    app_az1    = string
    app_az2    = string
    db_az1     = string
    db_az2     = string
  })
}
