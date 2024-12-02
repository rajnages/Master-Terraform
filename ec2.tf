resource "aws_instance" "base_instance" {
  ami           = var.ami_id            # Use an existing base AMI
  instance_type = var.instance_type     # Instance type (e.g., t2.micro)
  subnet_id     = var.public_subnet_id  # Subnet ID for the instance
  key_name      = var.key_name          # Key pair for SSH access

  # Add security group and IAM role
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  # Add root volume configuration
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  # Add user data script
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name        = "base-instance"
    Environment = var.environment
    Terraform   = "true"
  }
}
