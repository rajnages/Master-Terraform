resource "aws_vpc" "terraform-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.vpc_tags
}

resource "aws_internet_gateway" "terraform-IGW" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = merge(local.common_tags, {
    Name = "${local.vpc_name}-IGW"
  })
}

# This subnet resource creates a public subnet in the VPC
# vpc_id: Links the subnet to the VPC created above
# cidr_block: Defines the IP range for this subnet using a variable
# map_public_ip_on_launch: When true, instances launched in this subnet will get public IPs by default
resource "aws_subnet" "public-subnet" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.terraform-vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(local.public_subnet_tags, {
    Name = "${local.vpc_name}-public-${var.availability_zones[count.index]}"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.private_subnet_tags, {
    Name = "${local.vpc_name}-private-${var.availability_zones[count.index]}"
  })
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-IGW.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.vpc_name}-public-rt"
    Tier = "Public"
  })
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = merge(local.common_tags, {
    Name = "${local.vpc_name}-private-rt"
    Tier = "Private"
  })
}

# Route Table Associations - Public
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations - Private
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
