
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.subnets["public_az1"].id,
    aws_subnet.subnets["public_az2"].id
  ]
}

output "private_app_subnet_ids" {
  value = [
    aws_subnet.subnets["app_az1"].id,
    aws_subnet.subnets["app_az2"].id
  ]
}

output "private_db_subnet_ids" {
  value = [
    aws_subnet.subnets["db_az1"].id,
    aws_subnet.subnets["db_az2"].id
  ]
}

output "s3_vpc_endpoint_id" {
  description = "ID del VPC Endpoint de S3"
  value       = aws_vpc_endpoint.s3.id
}

