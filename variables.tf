variable "cidr" {
  description = "CIDR IP range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "vpc"
}
variable "aws_vpc" {
  description = "AWS VPC name"
  type        = string
  default     = "vpc"
}
variable "owner" {
  description = "Owner name"
  type        = string
  default     = "owner"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# variable "ami_id" {
#   description = "This is ami id"
#   type = string
# }

variable "instance_type" {
  description = "This is instance_type"
  type        = string
}

variable "key_name" {
  description = "This is key_name"
  type        = string
}
variable "instance_count" {}
variable "db_name" {}
variable "db_storage" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_max_storage" {}
