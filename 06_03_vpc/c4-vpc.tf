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

# NAT Gateway

# Public Route Table

# Public Route Table Associated to Oublic Subnet

# Private Route Table

# Private Route Table Associated to Private Subnet