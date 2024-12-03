# This Terraform configuration block specifies required providers and backend configuration
terraform {
  # Defines AWS as a required provider with specific version constraints
  # ~> 3.0 means any version in the 3.x series (3.1, 3.2 etc) but not 4.x
  # This helps maintain compatibility and prevents breaking changes
  #   required_providers {
  #     aws = {
  #       source  = "hashicorp/aws"
  #       version = "~> 3.0"
  #     }
  #   }

  # S3 backend configuration for storing Terraform state remotely
  # This solves several problems:
  # 1. Team collaboration - Multiple users can access the same state
  # 2. State locking via DynamoDB prevents concurrent modifications
  # 3. Secure storage - State file is encrypted at rest in S3
  # 4. Versioning - S3 can version state files for backup/rollback
  backend "s3" {
    bucket         = "my-terraform-state-file-prod-123"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

# AWS Provider configuration
# Specifies which AWS region to deploy resources in
# Region is parameterized using a variable for flexibility across environments
provider "aws" {
  region = var.aws_region
}
