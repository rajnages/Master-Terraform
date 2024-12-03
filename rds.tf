# Secrets Manager for RDS credentials
resource "aws_secretsmanager_secret" "cred" {
  name_prefix = "${var.environment}-${var.db_name}-rds"
  description = "Credentials for RDS database ${var.db_name} in ${var.environment}"

  tags = merge(local.common_tags, {
    Name        = var.db_name
    Environment = var.environment
    Purpose     = "RDS Credentials"
  })
}

# Generate random password for RDS
resource "random_password" "rds_admin" {
  length           = 32
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
  min_lower        = 5
  min_upper        = 5
  min_numeric      = 5
  min_special      = 5
}

# Create the secret version with the generated password
resource "aws_secretsmanager_secret_version" "my_cred" {
  secret_id = aws_secretsmanager_secret.cred.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_admin.result
  })
}

# RDS Subnet Group with private subnets only
resource "aws_db_subnet_group" "main_db" {
  name_prefix = "${var.environment}-${var.db_name}-db"
  subnet_ids  = aws_subnet.private[*].id

  tags = merge(local.rds_tags, {
    Name        = var.db_name
    Environment = var.environment
  })
}

# RDS Instance with enhanced security and monitoring
resource "aws_db_instance" "main_db" {
  identifier_prefix = "${lower(var.environment)}-${lower(var.db_name)}-main-db"
  allocated_storage     = var.db_storage
  max_allocated_storage = var.db_max_storage
  storage_type          = "gp3"
  storage_encrypted     = true
#   kms_key_id            = aws_kms_key.rds_key.id

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  # Reference the created secret for credentials
  username = var.db_username
  password = random_password.rds_admin.result

  tags = merge(local.rds_tags, {
    Name        = var.db_name
    Environment = var.environment
    Backup      = "true"
    Monitoring  = "true"
  })
}
