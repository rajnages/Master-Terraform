output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.terraform-vpc.id
}

output "igw_id" {
  description = "The ID of the IGW"
  value       = aws_internet_gateway.terraform-IGW.id
}
