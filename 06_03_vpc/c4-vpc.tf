# Resources
# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc"})
  lifecycle {
    prevent_destroy = false # In production must be true.
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
    tags = merge(var.tags, { Name = "${var.environment_name}-igw"})
}
# Public Subnets (3 Subnets to be generated)
resource "aws_subnet" "public" {
  for_each = { for idx, az in local.azs : az => local.public_subnets[idx] }  
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.environment_name}-public-${each.key}"})
}

# Private Subnets (3 Subnets to be generated)
resource "aws_subnet" "private" {
  for_each = { for idx, az in local.azs : az => local.private_subnets[idx] }  
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  tags = merge(var.tags, { Name = "${var.environment_name}-private-${each.key}"})
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
    tags = merge(var.tags, { Name = "${var.environment_name}-nat-iip"})
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.example.id # TODO: Get from the multiple subnets created.

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.example]
}

# Public Route Table

# Public Route Table Associated to Oublic Subnet

# Private Route Table

# Private Route Table Associated to Private Subnet