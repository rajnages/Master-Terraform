# This resource block creates EC2 instances in AWS
resource "aws_instance" "Web-Instance" {
  # Creates multiple instances based on the number of public subnets defined
  count         = length(var.public_subnet_cidrs)

  # Specifies the Amazon Machine Image ID to use for the instance
  ami           = var.ami_id

  # Defines the instance size/type (e.g. t2.micro, t2.small etc)
  instance_type = var.instance_type

  # Places each instance in a different public subnet using count.index
  subnet_id = aws_subnet.public-subnet[count.index].id

  # SSH key pair name for connecting to the instance
  key_name  = var.key_name

  # Associates security group that allows SSH access
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Commented out IAM role association
  #   iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  # Configures the root EBS volume
  root_block_device {
    volume_size = 20        # Size in GB
    volume_type = "gp3"     # General Purpose SSD
    encrypted   = true      # Enables EBS encryption
  }

  # Bootstrap script that runs when instance launches
  user_data = <<-EOF
              #!/bin/bash
              # Updates the system packages
              sudo apt-get update -y
              # Installs Apache web server
              sudo apt-get install -y apache2
              # Starts and enables Apache to run on boot
              sudo systemctl start apache2
              sudo systemctl enable apache2

              # Creates a basic web page
              echo "<html><body><h1>Hello from Instance $(hostname)</h1></body></html>" > /var/www/html/index.html

              # Verifies Apache is running
              sudo systemctl status apache2
              EOF

  # Adds tags to the instance for identification and management
  tags = {
    Name        = "base-instance"
    Environment = var.environment
    Terraform   = "true"
  }
}
