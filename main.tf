provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

# VPC
resource "aws_vpc" "itra_vpc" {
  cidr_block = var.vpc_cidr
}

# Internet Gateway
resource "aws_internet_gateway" "itra_internet_gateway" {
  vpc_id = aws_vpc.itra_vpc.id
}

# Public Subnets
resource "aws_subnet" "itra_public_subnets" {
  for_each          = var.resources
  vpc_id            = aws_vpc.itra_vpc.id
  availability_zone = each.key
  cidr_block        = each.value.public_subnet_cidr

  tags = {
    Name = "Public Subnet - ${each.key}"
  }
}

# Private Subnets
resource "aws_subnet" "itra_private_subnets" {
  for_each          = var.resources
  vpc_id            = aws_vpc.itra_vpc.id
  availability_zone = each.key
  cidr_block        = each.value.private_subnet_cidr

  tags = {
    Name = "Private Subnet - ${each.key}"
  }
}

# Elastic IPs
resource "aws_eip" "itra_eip" {
  for_each   = aws_subnet.itra_public_subnets
  depends_on = [aws_internet_gateway.itra_internet_gateway]

  tags = {
    Name = "EIP-${each.key}"
  }
}

# NATs
resource "aws_nat_gateway" "itra_nat" {
  for_each      = aws_subnet.itra_public_subnets
  subnet_id     = each.value.id
  allocation_id = aws_eip.itra_eip[each.key].id

  tags = {
    Name = "NAT-${each.key}"
  }
}

# Public Route Table
resource "aws_route_table" "itra_public_route_table" {
  vpc_id = aws_vpc.itra_vpc.id
  route {
    cidr_block = var.rtb_cidr
    gateway_id = aws_internet_gateway.itra_internet_gateway.id
  }

  tags = {
    Name = "Public RTB"
  }
}

# Private Route Tables
resource "aws_route_table" "itra_private_route_table" {
  for_each = aws_nat_gateway.itra_nat
  vpc_id   = aws_vpc.itra_vpc.id
  route {
    cidr_block     = var.rtb_cidr
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "Private RTB-${each.key}"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "itra_public_rtba" {
  for_each       = aws_subnet.itra_public_subnets
  route_table_id = aws_route_table.itra_public_route_table.id
  subnet_id      = each.value.id
}

#Private Route Table Assocations
resource "aws_route_table_association" "itra_private_rtba" {
  for_each       = aws_subnet.itra_private_subnets
  route_table_id = aws_route_table.itra_private_route_table[each.key].id
  subnet_id      = each.value.id
}
