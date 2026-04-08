# Resources
# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc"})
}

# Internet Gateway

# Public Subnets

# Private Subnets

# Elastic IP for NAT Gateway

# NAT Gateway

# Public Route Table

# Public Route Table Associated to Oublic Subnet

# Private Route Table

# Private Route Table Associated to Private Subnet