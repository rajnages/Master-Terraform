# Data block to fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}
# This resource block creates EC2 instances in AWS
resource "aws_instance" "Web-Instance" {
  # Creates multiple instances based on the number of public subnets defined
  count = length(var.public_subnet_cidrs)

  # Specifies the Amazon Machine Image ID to use for the instance
  ami = data.aws_ami.ubuntu.id

  # Defines the instance size/type (e.g. t2.micro, t2.small etc)
  instance_type = var.instance_type

  # Places each instance in a different public subnet using count.index
  subnet_id = aws_subnet.public-subnet[count.index].id

  # SSH key pair name for connecting to the instance
  key_name = var.key_name

  # Associates security group that allows SSH access
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Commented out IAM role association
  #   iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  # Configures the root EBS volume
  root_block_device {
    volume_size = 20    # Size in GB
    volume_type = "gp3" # General Purpose SSD
    encrypted   = true  # Enables EBS encryption
  }

  # Adds tags to the instance for identification and management
  tags = {
    Name        = "base-instance"
    Environment = var.environment
    Terraform   = "true"
  }
}


# This null_resource is used to update userdata on EC2 instances after they are created
# resource "null_resource" "update_userdata" {
#   # Creates one null_resource for each public subnet/EC2 instance
#   count = length(var.public_subnet_cidrs)

#   # Triggers the resource to be recreated when userdata.sh changes or instance changes
#   triggers = {
#     always_run = "${timestamp()}"
#   }

# Configures SSH connection details to connect to the EC2 instance
#   connection {
#     type        = "ssh"
#     host        = aws_instance.Web-Instance[count.index].public_ip
#     user        = "ubuntu"
#     private_key = file("C:/Users/rajnages/Downloads/${var.key_name}.pem")
#     timeout     = "5m" # Added timeout to ensure connection is established
#   }

# Copies the userdata.sh script to the instance
#   provisioner "file" {
#        command = "echo This specific command will execute every time during apply as triggers are used"
#   }

# Executes commands on the instance to:
# 1. Verify file exists in /tmp
# 2. Make the script executable
# 3. Copy it to cloud-init scripts directory
# 4. Restart cloud-init to apply the new userdata
#   provisioner "local-exec" {
#     command = "echo This specific command will execute every time during apply as triggers are used"
#   }

#   # Ensures new resource is created before destroying old one
#   lifecycle {
#     create_before_destroy = true
#   }

#   # Add dependency to ensure instance is fully ready
#   depends_on = [
#     aws_instance.Web-Instance
#   ]
