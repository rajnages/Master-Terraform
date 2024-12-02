locals {
  vpc_name = "${var.project_name}-${var.environment}-vpc"

  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Infrastructure Team"
  }

  vpc_tags = merge(local.common_tags, {
    Name = local.vpc_name
    Type = "VPC"
  })

  igw_tags = merge (local.common_tags, {
    Name = "Public"
    Type = "Internet Gateway"
  })

  public_subnet_tags = merge(local.common_tags, {
    Tier = "Public"
    Type = "Subnet"
  })

  private_subnet_tags = merge(local.common_tags, {
    Tier = "Private"
    Type = "Subnet"
  })
}
