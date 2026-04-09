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
    tags = merge(var.tags, { Name = "${var.environment_name}-nat-eip"})
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id 
    # > values({"us-east-1a"="10.0.0.0/24", "us-east-1b"="10.0.1.0/24", "us-east-1c"="10.0.2.0/24"})
    # [
    #   "10.0.0.0/24",
    #   "10.0.1.0/24",
    #   "10.0.2.0/24",
    # ]
    # >  
  tags = merge(var.tags, { Name = "${var.environment_name}-nat"})

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-public-rt"})
}

# Public Route Table Associated to Oublic Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # Where private subnet is allowed to go to internet
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-private-rt"})
}

# Private Route Table Associated to Private Subnet
resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}